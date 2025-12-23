import 'package:incisive/log/main_logger.dart';
import 'package:incisive/models/user_model.dart';
import 'package:incisive/source/remote/user_service.dart';

class UserRepository {
  final UserService userService;

  UserRepository({required this.userService});

  Future<UserModel?> getUser() async {
    try {
      MainLogger.logInfo("Try to get user");
      return await userService.getUser();
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }
}
