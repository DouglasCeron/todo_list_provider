// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';

import 'package:todo_list_provider/app/repositories/user_repository.dart';
import 'package:todo_list_provider/app/services/user/user_service.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  UserServiceImpl({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  @override
  Future<User?> register(String email, String password) {
    return _userRepository.registerUser(email, password);
  }

  @override
  Future<User?> login(String email, String password) {
    return _userRepository.login(email, password);
  }

  @override
  Future<User?> forgotPassword(String email) {
    return _userRepository.forgotPassword(email);
  }
}
