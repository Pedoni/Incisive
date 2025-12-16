import 'package:incisive/log/main_logger.dart';
import 'package:incisive/source/remote/user_service.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class UserRepository {
  final UserService userService;

  UserRepository({required this.userService});

  Future<User?> getUser() async {
    try {
      MainLogger.logInfo("Try to get page");
      return await userService.getUser();
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }
}
