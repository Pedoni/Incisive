import 'package:incisive/repositories/base_repository.dart';
import 'package:incisive/source/remote/login_service.dart';

class LoginRepository extends BaseRepository {
  final LoginService loginService;

  LoginRepository({required this.loginService});

  Future<void> login(String email, String password) async {
    return await guard(
      'Login user',
      () => loginService.login(email, password),
    );
  }

  Future<void> logout() async {
    return await guard(
      'Logout user',
      () => loginService.logout(),
    );
  }

  Future<void> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    return await guard(
      'Register user',
      () => loginService.register(
        email,
        password,
        firstName,
        lastName,
      ),
    );
  }
}
