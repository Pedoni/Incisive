import 'package:incisive/log/main_logger.dart';
import 'package:incisive/models/social_post_model.dart';
import 'package:incisive/source/remote/social_service.dart';

class SocialRepository {
  final SocialService socialService;

  SocialRepository({required this.socialService});

  Future<List<SocialPostModel>> getDailyPosts(DateTime dateTime) async {
    try {
      MainLogger.logInfo("Try to get daily posts");
      final list = await socialService.getDailyPosts(date: dateTime);
      return list
          .map(
            (e) => SocialPostModel(
              id: e['id'],
              content: e['content'],
              datetime: DateTime.parse(e['datetime']),
              authorId: e['authorId'],
              title: e['title'],
            ),
          )
          .toList();
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> createPost(SocialPostModel post) async {
    try {
      MainLogger.logInfo("Try to add new post");
      await socialService.createPost(
        content: post.content,
        title: post.title,
      );
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }
}
