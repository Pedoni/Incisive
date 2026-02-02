import 'package:incisive/utils/functions.dart';
import 'package:pine/dto/dto.dart';
import 'package:equatable/equatable.dart';

final class UserDTO extends DTO with EquatableMixin {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final int points;
  final int level;
  final num progress;
  final int nextLevelPoints;
  final int spentPoints;
  final String avatarAsset;

  UserDTO.fromJson(JsonObject json)
    : id = json['id'] as String,
      firstName = json['firstName'] as String,
      lastName = json['lastName'] as String,
      email = json['email'] as String,
      points = json['points'] as int,
      level = json['level'] as int,
      progress = json['progress'] as num,
      nextLevelPoints = json['next_level_points'] as int,
      spentPoints = json['spent_points'] as int,
      avatarAsset = json['avatar_asset'] as String;

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    points,
    level,
    progress,
    nextLevelPoints,
    spentPoints,
    avatarAsset,
  ];
}
