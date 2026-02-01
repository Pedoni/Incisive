import 'package:incisive/mappers/dto/user_dto.dart';
import 'package:incisive/models/user_model.dart';
import 'package:pine/utils/dto_mapper.dart';

class UserMapper extends DTOMapper<UserDTO, UserModel> {
  @override
  UserModel fromDTO(UserDTO dto) {
    return UserModel(
      id: dto.id,
      firstName: dto.firstName,
      lastName: dto.lastName,
      email: dto.email,
      points: dto.points,
      level: dto.level,
      progress: dto.progress.toDouble(),
      nextLevelPoints: dto.nextLevelPoints,
      spentPoints: dto.spentPoints,
    );
  }

  @override
  UserDTO toDTO(UserModel model) {
    return UserDTO.fromJson({
      'id': model.id,
      'firstName': model.firstName,
      'lastName': model.lastName,
      'email': model.email,
      'points': model.points,
      'level': model.level,
      'progress': model.progress,
      'next_level_points': model.nextLevelPoints,
      'spent_points': model.spentPoints,
    });
  }
}
