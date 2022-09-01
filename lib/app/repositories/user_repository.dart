import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepository {
  Future<User?> registerUser(String email, String password);
}
