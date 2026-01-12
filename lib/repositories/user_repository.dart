import 'package:incisive/models/user_model.dart';
import 'package:incisive/repositories/base_repository.dart';
import 'package:incisive/source/remote/user_service.dart';

class UserRepository extends BaseRepository {
  final UserService userService;

  UserRepository({required this.userService});

  /// =========================
  /// GET USER
  /// =========================

  Future<UserModel> getUser() {
    return guard(
      'Get user profile',
      () => userService.getUser(),
    );
  }

  /// =========================
  /// ADD POINTS
  /// =========================

  Future<void> addPoints({
    required int points,
  }) {
    return guard(
      'Add user points',
      () => userService.addPoints(points: points),
    );
  }
}
