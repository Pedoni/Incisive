import 'package:incisive/utils/exceptions.dart';
import 'package:incisive/utils/functions.dart';
import 'package:incisive/source/remote/base_service.dart';

class SocialService extends BaseService {
  /// =========================
  /// POSTS
  /// =========================

  Future<List<Map<String, dynamic>>> getDailyPosts({
    required DateTime date,
  }) async {
    final from = startOfDay(date).toUtc();
    final to = startOfNextDay(date).toUtc();

    final response = await supabase
        .from('social_post')
        .select('''
          id,
          datetime,
          authorId,
          content,
          title,
          social_comment!left(count)
        ''')
        .eq('social_comment.approved', true)
        .gte('datetime', from.toIso8601String())
        .lt('datetime', to.toIso8601String())
        .order('datetime', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> createPost({
    required String title,
    required String content,
  }) async {
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
  }

  /// =========================
  /// COMMENTS
  /// =========================

  Future<List<Map<String, dynamic>>> getCommentsForPost({
    required String postId,
  }) async {
    final response = await supabase
        .from('social_comment')
        .select('''
          id,
          post_id,
          author_id,
          content,
          created_at,
          approved,

          social_comment_vote!left(
            is_upvote,
            user_id
          )
        ''')
        .eq('post_id', postId)
        .order('created_at', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> createComment({
    required String postId,
    required String content,
  }) async {
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
  }

  Future<void> approveComment({
    required String commentId,
  }) async {
    try {
      await supabase.rpc(
        'approve_social_comment',
        params: {
          'p_comment_id': commentId,
        },
      );
    } catch (e) {
      if (e.toString().contains('NOT_AUTHORIZED')) {
        throw IncisiveException(
          'Non sei autorizzato ad approvare questo commento!',
        );
      }
      rethrow;
    }
  }

  Future<void> rejectComment({
    required String commentId,
  }) async {
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
  }

  /// =========================
  /// VOTES
  /// =========================

  Future<void> voteComment({
    required String commentId,
    required bool isUpvote,
  }) async {
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
  }
}
