import 'package:incisive/utils/functions.dart';
import 'package:pine/dto/dto.dart';
import 'package:equatable/equatable.dart';

final class PostDTO extends DTO with EquatableMixin {
  final String id;
  final String content;
  final String datetime;
  final String authorId;
  final String title;
  final int approvedCommentsCount;

  PostDTO.fromJson(JsonObject json)
    : id = json['id'] as String,
      content = json['content'] as String,
      datetime = json['datetime'] as String,
      authorId = json['authorId'] as String,
      title = json['title'] as String,
      approvedCommentsCount = json['approved_comment_count'] as int;

  @override
  List<Object?> get props => [
    id,
    content,
    datetime,
    authorId,
    title,
    approvedCommentsCount,
  ];
}
