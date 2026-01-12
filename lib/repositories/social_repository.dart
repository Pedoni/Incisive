import 'package:incisive/models/social_comment_model.dart';
import 'package:incisive/models/social_post_model.dart';
import 'package:incisive/repositories/base_repository.dart';
import 'package:incisive/source/remote/social_service.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SocialRepository extends BaseRepository {
  final SocialService socialService;

  SocialRepository({required this.socialService});

  /// =========================
  /// POSTS
  /// =========================

  Future<List<SocialPostModel>> getDailyPosts(DateTime date) {
    return guard(
      'Get daily social posts',
      () async {
        final list = await socialService.getDailyPosts(date: date);

        return list.map((e) {
          final comments = e['social_comment'] as List<dynamic>?;
          final approvedCount = comments != null && comments.isNotEmpty ? comments.first['count'] as int : 0;

          return SocialPostModel(
            id: e['id'],
            content: e['content'],
            datetime: DateTime.parse(e['datetime']),
            authorId: e['authorId'],
            title: e['title'],
            approvedCommentsCount: approvedCount,
          );
        }).toList();
      },
    );
  }

  Future<void> createPost({
    required String title,
    required String content,
  }) {
    return guard(
      'Create social post',
      () => socialService.createPost(
        title: title,
        content: content,
      ),
    );
  }

  /// =========================
  /// COMMENTS
  /// =========================

  Future<List<SocialCommentModel>> getCommentsForPost({
    required String postId,
  }) {
    return guard(
      'Get comments for post $postId',
      () async {
        final response = await socialService.getCommentsForPost(postId: postId);

        final viewerUserId = Supabase.instance.client.auth.currentUser!.id;

        return response
            .map(
              (e) => SocialCommentModel.fromMap(
                e,
                viewerUserId: viewerUserId,
              ),
            )
            .toList();
      },
    );
  }

  Future<void> createComment({
    required String postId,
    required String content,
  }) {
    return guard(
      'Create comment on post $postId',
      () => socialService.createComment(
        postId: postId,
        content: content,
      ),
    );
  }

  Future<void> approveComment({
    required String commentId,
  }) {
    return guard(
      'Approve comment $commentId',
      () => socialService.approveComment(
        commentId: commentId,
      ),
    );
  }

  Future<void> rejectComment({
    required String commentId,
  }) {
    return guard(
      'Reject comment $commentId',
      () => socialService.rejectComment(
        commentId: commentId,
      ),
    );
  }

  Future<void> voteComment({
    required String commentId,
    required bool isUpvote,
  }) {
    return guard(
      'Vote comment $commentId (upvote=$isUpvote)',
      () => socialService.voteComment(
        commentId: commentId,
        isUpvote: isUpvote,
      ),
    );
  }
}
