import 'package:incisive/utils/functions.dart';
import 'package:pine/dto/dto.dart';
import 'package:equatable/equatable.dart';

final class PostDTO extends DTO with EquatableMixin {
  final String id;
  final String content;
  final String datetime;
  final String title;
  final int approvedCommentsCount;
  final bool visible;
  final PostAuthorDTO author;

  PostDTO.fromJson(JsonObject json)
    : id = json['id'] as String,
      content = json['content'] as String,
      datetime = json['datetime'] as String,
      title = json['title'] as String,
      approvedCommentsCount = (json['approved_comments_count'] as int?) ?? 0,
      visible = json['visible'] as bool,
      author = PostAuthorDTO.fromJson(json['author'] as JsonObject);

  @override
  List<Object?> get props => [
    id,
    content,
    datetime,
    title,
    approvedCommentsCount,
    author,
  ];
}

final class PostAuthorDTO extends DTO with EquatableMixin {
  final String id;
  final String firstName;
  final String lastName;
  final String avatarAsset;
  final int level;

  PostAuthorDTO.fromJson(JsonObject json)
    : id = json['id'] as String,
      firstName = json['firstName'] as String,
      lastName = json['lastName'] as String,
      avatarAsset = json['avatar_asset'] as String,
      level = (json['level'] as int?) ?? 1;

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    avatarAsset,
    level,
  ];
}
