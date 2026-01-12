import 'package:incisive/log/main_logger.dart';
import 'package:incisive/models/social_comment_model.dart';
import 'package:incisive/models/social_post_model.dart';
import 'package:incisive/source/remote/social_service.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SocialRepository {
  final SocialService socialService;

  SocialRepository({required this.socialService});

  Future<List<SocialPostModel>> getDailyPosts(DateTime dateTime) async {
    try {
      MainLogger.logInfo("Try to get daily posts");
      final list = await socialService.getDailyPosts(date: dateTime);

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
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> createPost({required String title, required String content}) async {
    try {
      MainLogger.logInfo("Try to add new post");
      await socialService.createPost(
        content: content,
        title: title,
      );
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<List<SocialCommentModel>> getCommentsForPost({
    required String postId,
  }) async {
    try {
      MainLogger.logInfo("Try to get comments for post $postId");

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
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> createComment({
    required String postId,
    required String content,
  }) async {
    try {
      MainLogger.logInfo("Try to create comment on post $postId");

      await socialService.createComment(
        postId: postId,
        content: content,
      );
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> approveComment({
    required String commentId,
  }) async {
    try {
      MainLogger.logInfo("Try to approve comment $commentId");

      await socialService.approveComment(
        commentId: commentId,
      );
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> rejectComment({
    required String commentId,
  }) async {
    try {
      MainLogger.logInfo("Try to reject comment $commentId");
      await socialService.rejectComment(commentId: commentId);
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> voteComment({
    required String commentId,
    required bool isUpvote,
  }) async {
    try {
      MainLogger.logInfo("Try to vote comment $commentId (upvote=$isUpvote)");

      await socialService.voteComment(
        commentId: commentId,
        isUpvote: isUpvote,
      );
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }
}
