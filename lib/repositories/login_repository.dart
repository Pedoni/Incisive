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

  Future<void> logout() async {
    try {
      MainLogger.logInfo("Try to logout");
      await loginService.logout();
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      MainLogger.logInfo("Try to login");
      await loginService.register(email, password, firstName, lastName);
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }
}
