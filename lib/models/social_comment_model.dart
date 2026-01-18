import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SocialCommentModel {
  final String id;
  final String postId;
  final String authorId;
  final String content;
  final DateTime createdAt;
  final bool approved;
  final int upvotes;
  final int downvotes;
  final bool? myVote;
  final String viewerUserId;

  SocialCommentModel({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.content,
    required this.createdAt,
    required this.approved,
    required this.upvotes,
    required this.downvotes,
    required this.viewerUserId,
    this.myVote,
  });

  factory SocialCommentModel.fromMap(Map<String, dynamic> map) {
    return SocialCommentModel(
      id: map['id'],
      postId: map['post_id'],
      authorId: map['author_id'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
      approved: map['approved'],
      upvotes: map['upvotes'],
      downvotes: map['downvotes'],
      myVote: map['my_vote'],
      viewerUserId: Supabase.instance.client.auth.currentUser!.id,
    );
  }
}
