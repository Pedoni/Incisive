import 'package:incisive/models/user_model.dart';
import 'package:incisive/repositories/base_repository.dart';
import 'package:incisive/source/remote/user_service.dart';

class UserRepository extends BaseRepository {
  final UserService userService;

  UserRepository({required this.userService});

  Future<UserModel> getUser() async {
    return await guard(
      'Get user profile',
      () => userService.getUser(),
    );
  }

  Future<void> addPoints({required int points}) async {
    return await guard(
      'Add user points',
      () => userService.addPoints(points: points),
    );
  }
}
