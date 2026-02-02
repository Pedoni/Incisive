import 'package:incisive/mappers/dto/user_dto.dart';
import 'package:incisive/models/avatar_model.dart';
import 'package:incisive/models/user_model.dart';
import 'package:incisive/repositories/base_repository.dart';
import 'package:incisive/source/remote/user_service.dart';
import 'package:pine/utils/dto_mapper.dart';

class UserRepository extends BaseRepository {
  final UserService userService;
  final DTOMapper<UserDTO, UserModel> userMapper;

  UserRepository({
    required this.userService,
    required this.userMapper,
  });

  Future<UserModel> getUser() async {
    return await guard(
      'Get user profile',
      () async {
        final json = await userService.getUserWithProgress();
        return userMapper.fromDTO(UserDTO.fromJson(json));
      },
    );
  }

  Future<void> addPoints({required int points}) async {
    return await guard(
      'Add user points',
      () => userService.addPoints(points: points),
    );
  }

  Future<List<AvatarModel>> getAvatars() async {
    return await guard(
      'Get user avatars',
      () async {
        final json = await userService.getAvatars();

        return json.map((e) => AvatarModel.fromJson(e)).toList();
      },
    );
  }

  Future<void> purchaseAvatar(String avatarId) async {
    return await guard(
      'Purchase avatar',
      () async {
        await userService.purchaseAvatar(avatarId);
      },
    );
  }

  Future<void> equipAvatar(String avatarId) async {
    return await guard(
      'Equip avatar',
      () async {
        await userService.equipAvatar(avatarId);
      },
    );
  }
}
