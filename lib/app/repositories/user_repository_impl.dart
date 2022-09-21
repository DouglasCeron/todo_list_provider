import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list_provider/app/exception/auth_exception.dart';
import 'package:todo_list_provider/app/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> registerUser(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }

      if (e.code == 'email-already-in-use') {
        final loginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
        if (loginTypes.contains('password')) {
          throw AuthException(
              message: 'E-mail ja cadatrado, escolha outro e-mail');
        } else {
          throw AuthException(
              message:
                  'Cadastro realizado pelo Google, favor acessar utilizando Google');
        }
      } else {
        throw AuthException(message: e.message ?? 'Erro ao registrar usuário');
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return userCredential.user;
    } on PlatformException catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
      throw AuthException(message: e.message ?? 'Erro ao realizar o login');
    } on FirebaseAuthException catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
        if (e.message ==
            'There is no user record corresponding to this identifier. The user may have been deleted.') {
          throw AuthException(
              message: 'Não foi encontrado usuario cadastrado com esse email');
        }
      }
      throw AuthException(
          message: e.message ?? 'Erro ao realizar o login no FireBase');
    }
  }

  @override
  Future<User?> forgotPassword(String email) async {
    try {
      final loginMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);
      if (loginMethods.contains('password')) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (loginMethods.contains('google')) {
        throw AuthException(message: 'Cadastro realizado pelo Google');
      } else {
        throw AuthException(message: 'E-mail não encontrado');
      }
    } on PlatformException catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
        throw AuthException(message: 'Erro ao resetar senha');
      }
    }
  }

  @override
  Future<User?> googleLogin() async {
    List<String>? loginMethods;

    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        loginMethods =
            await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);
        if (loginMethods.contains('password')) {
          throw AuthException(
            message:
                'Você utilizou o e-mail para cadastro, caso esqueceu a senha clique no lick - Esqueceu sua senha - ',
          );
        } else {
          final googleAuth = await googleUser.authentication;
          final firebaseCredential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          var userCredential =
              await _firebaseAuth.signInWithCredential(firebaseCredential);
          return userCredential.user;
        }
      }
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'account-exists-with-different-credential') {
        throw AuthException(message: '''
          Login invalido, 
          ${loginMethods?.join(',')}
          ''');
      } else {
        throw AuthException(message: 'Erro ao realizar o Login');
      }
    }
  }

  @override
  Future<void> googleLogout() async {
    await GoogleSignIn().signOut();
    _firebaseAuth.signOut();
  }
}
