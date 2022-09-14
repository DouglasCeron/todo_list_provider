import 'package:todo_list_provider/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list_provider/app/services/user/user_service.dart';

class LoginController extends DefaultChangeNotifier {
  final UserService _userService;

  LoginController({required UserService userService})
      : _userService = userService;

  void login(String email, String password) async {
    showLoadingAndResetState();
    notifyListeners();
    final user = await _userService.login(email, password);
  }
}
