import 'package:incisive/utils/functions.dart';
import 'package:pine/dto/dto.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

final class CommentDTO extends DTO with EquatableMixin {
  final String id;
  final String postId;
  final String authorId;
  final String content;
  final String createdAt;
  final bool approved;
  final int upvotes;
  final int downvotes;
  final bool? myVote;
  final String viewerUserId;

  CommentDTO.fromJson(JsonObject json)
    : id = json['id'] as String,
      postId = json['post_id'] as String,
      authorId = json['author_id'] as String,
      content = json['content'] as String,
      createdAt = json['created_at'] as String,
      approved = json['approved'] as bool,
      upvotes = json['upvotes'] as int,
      downvotes = json['downvotes'] as int,
      myVote = json['my_vote'] as bool?,
      viewerUserId = Supabase.instance.client.auth.currentUser!.id;

  @override
  List<Object?> get props => [
    id,
    postId,
    authorId,
    content,
    createdAt,
    approved,
    upvotes,
    downvotes,
    myVote,
    viewerUserId,
  ];
}
