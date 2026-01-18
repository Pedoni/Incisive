import 'package:incisive/mappers/dto/post_dto.dart';
import 'package:incisive/models/social_comment_model.dart';
import 'package:incisive/models/social_post_model.dart';
import 'package:incisive/repositories/base_repository.dart';
import 'package:incisive/source/remote/social_service.dart';
import 'package:pine/pine.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SocialRepository extends BaseRepository {
  final SocialService socialService;
  final DTOMapper<PostDTO, SocialPostModel> postMapper;

  SocialRepository({
    required this.socialService,
    required this.postMapper,
  });

  Future<List<SocialPostModel>> getDailyPosts(DateTime date) async {
    return await guard(
      'Get daily social posts',
      () async {
        final list = await socialService.getDailyPosts(date: date);
        return postMapper.fromDTOMany(list.map((e) => PostDTO.fromJson(e))).toList();
      },
    );
  }

  Future<void> createPost({
    required String title,
    required String content,
  }) async {
    return await guard(
      'Create social post',
      () => socialService.createPost(
        title: title,
        content: content,
      ),
    );
  }

  Future<List<SocialCommentModel>> getCommentsForPost({
    required String postId,
  }) async {
    return await guard(
      'Get comments for post $postId',
      () async {
        final response = await socialService.getCommentsForPost(postId: postId);

        return response.map((e) => SocialCommentModel.fromMap(e)).toList();
      },
    );
  }

  Future<void> createComment({
    required String postId,
    required String content,
  }) async {
    return await guard(
      'Create comment on post $postId',
      () => socialService.createComment(
        postId: postId,
        content: content,
      ),
    );
  }

  Future<void> approveComment({required String commentId}) async {
    return await guard(
      'Approve comment $commentId',
      () => socialService.approveComment(
        commentId: commentId,
      ),
    );
  }

  Future<void> rejectComment({required String commentId}) async {
    return await guard(
      'Reject comment $commentId',
      () => socialService.rejectComment(
        commentId: commentId,
      ),
    );
  }

  Future<void> voteComment({
    required String commentId,
    required bool isUpvote,
  }) async {
    return await guard(
      'Vote comment $commentId (upvote=$isUpvote)',
      () => socialService.voteComment(
        commentId: commentId,
        isUpvote: isUpvote,
      ),
    );
  }
}
