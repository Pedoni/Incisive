import 'package:incisive/utils/exceptions.dart';
import 'package:incisive/utils/functions.dart';
import 'package:incisive/source/remote/base_service.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SocialService extends BaseService {
  Future<JsonArray> getDailyPosts({required DateTime date}) async {
    return await guard("Get daily social posts", () async {
      final from = startOfDayUtc(date);
      final to = startOfNextDayUtc(date);

      final response = await supabase
          .from('social_post_with_approved_comment_count')
          .select()
          .gte('datetime', from.toIso8601String())
          .lt('datetime', to.toIso8601String())
          .order('datetime', ascending: false);

      return JsonArray.from(response);
    });
  }

  Future<void> createPost({
    required String title,
    required String content,
  }) async {
    return await guard("Create post", () async {
      try {
        await supabase.rpc(
          'create_social_post',
          params: {
            'p_title': title,
            'p_content': content,
          },
        );
      } catch (e) {
        final msg = e.toString();

        if (msg.contains('POST_ALREADY_CREATED_TODAY')) {
          throw IncisiveException('Hai già pubblicato un post oggi!');
        }

        rethrow;
      }
    });
  }

  Future<JsonArray> getCommentsForPost({required String postId}) async {
    return await guard(
      'Get comments for post (rpc)',
      () async {
        final res = await supabase.rpc(
          'get_post_comments',
          params: {
            'p_post_id': postId,
          },
        );

        return JsonArray.from(res ?? []);
      },
    );
  }

  Future<void> createComment({
    required String postId,
    required String content,
  }) async {
    return await guard("Create comment", () async {
      try {
        await supabase.rpc(
          'create_social_comment',
          params: {
            'p_post_id': postId,
            'p_content': content,
          },
        );
      } catch (e) {
        final msg = e.toString();

        if (msg.contains('AUTHOR_CANNOT_COMMENT')) {
          throw IncisiveException('Non puoi commentare il tuo stesso post!');
        }

        if (msg.contains('COMMENT_ALREADY_EXISTS')) {
          throw IncisiveException('Hai già commentato questo post!');
        }

        rethrow;
      }
    });
  }

  Future<void> approveComment({required String commentId}) async {
    return guard("Approve comment", () async {
      try {
        await supabase.rpc(
          'approve_social_comment',
          params: {'p_comment_id': commentId},
        );
      } on PostgrestException catch (e) {
        if (e.message.contains('NOT_AUTHORIZED')) {
          throw IncisiveException(
            'Non sei autorizzato ad approvare questo commento!',
          );
        }
        rethrow;
      }
    });
  }

  Future<void> rejectComment({required String commentId}) async {
    return await guard("Reject comment", () async {
      try {
        await supabase.rpc(
          'reject_social_comment',
          params: {
            'p_comment_id': commentId,
          },
        );
      } catch (e) {
        final msg = e.toString();

        if (msg.contains('NOT_AUTHORIZED')) {
          throw IncisiveException(
            'Non sei autorizzato a rifiutare questo commento!',
          );
        }

        if (msg.contains('COMMENT_NOT_FOUND')) {
          throw IncisiveException('Commento non trovato');
        }

        rethrow;
      }
    });
  }

  Future<void> voteComment({
    required String commentId,
    required bool isUpvote,
  }) async {
    return await guard("Vote comment", () async {
      try {
        await supabase.rpc(
          'vote_social_comment',
          params: {
            'p_comment_id': commentId,
            'p_is_upvote': isUpvote,
          },
        );
      } catch (_) {
        throw IncisiveException('Errore nel voto del commento');
      }
    });
  }
}
