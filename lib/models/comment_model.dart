import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class CommentModel {
  final String id;
  final String postId;
  final String content;
  final DateTime createdAt;
  final bool approved;
  final int upvotes;
  final int downvotes;
  final bool? myVote;
  final String viewerUserId;
  final CommentAuthorModel author;

  CommentModel({
    required this.id,
    required this.postId,
    required this.content,
    required this.createdAt,
    required this.approved,
    required this.upvotes,
    required this.downvotes,
    required this.viewerUserId,
    this.myVote,
    required this.author,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'],
      postId: map['post_id'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
      approved: map['approved'],
      upvotes: map['upvotes'],
      downvotes: map['downvotes'],
      myVote: map['my_vote'],
      viewerUserId: Supabase.instance.client.auth.currentUser!.id,
      author: CommentAuthorModel(
        id: map['author']['id'],
        avatarAsset: map['author']['avatar_asset'],
        level: map['author']['level'],
      ),
    );
  }
}

class CommentAuthorModel {
  final String id;
  final String avatarAsset;
  final int level;

  CommentAuthorModel({
    required this.id,
    required this.avatarAsset,
    required this.level,
  });
}
