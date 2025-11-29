import 'package:incisive/log/main_logger.dart';
import 'package:incisive/source/remote/login_service.dart';

class LoginRepository {
  final LoginService loginService;

  LoginRepository({required this.loginService});

  Future<void> login(String email, String password) async {
    try {
      MainLogger.logInfo("Try to login");
      await loginService.login(email, password);
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }
}
