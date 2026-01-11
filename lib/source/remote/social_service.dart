import 'package:incisive/utils/functions.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SocialService {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getDailyPosts({
    required DateTime date,
  }) async {
    final from = startOfDay(date).toUtc();
    final to = startOfNextDay(date).toUtc();

    final response = await _supabase
        .from('social_post')
        .select('''
          id,
          datetime,
          authorId,
          content,
          title
        ''')
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
      await _supabase.rpc(
        'create_social_post',
        params: {
          'p_title': title,
          'p_content': content,
        },
      );
    } catch (e) {
      if (e.toString().contains('POST_ALREADY_CREATED_TODAY')) {
        throw Exception(
          'Hai già pubblicato un post oggi 🌱',
        );
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getCommentsForPost({
    required String postId,
  }) async {
    final response = await _supabase
        .from('social_comment')
        .select('''
          id,
          post_id,
          author_id,
          content,
          created_at,
          approved,
          upvotes,
          downvotes
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
      await _supabase.rpc(
        'create_social_comment',
        params: {
          'p_post_id': postId,
          'p_content': content,
        },
      );
    } catch (e) {
      final msg = e.toString();

      if (msg.contains('AUTHOR_CANNOT_COMMENT')) {
        throw Exception('Non puoi commentare il tuo stesso post');
      }

      if (msg.contains('COMMENT_ALREADY_EXISTS')) {
        throw Exception('Hai già commentato questo post');
      }

      rethrow;
    }
  }

  Future<void> approveComment({
    required String commentId,
  }) async {
    try {
      await _supabase.rpc(
        'approve_social_comment',
        params: {
          'p_comment_id': commentId,
        },
      );
    } catch (e) {
      if (e.toString().contains('NOT_AUTHORIZED')) {
        throw Exception('Non sei autorizzato ad approvare questo commento');
      }
      rethrow;
    }
  }

  Future<void> rejectComment({
    required String commentId,
  }) async {
    try {
      await _supabase.rpc(
        'reject_social_comment',
        params: {
          'p_comment_id': commentId,
        },
      );
    } catch (e) {
      if (e.toString().contains('NOT_AUTHORIZED')) {
        throw Exception('Non sei autorizzato a rifiutare questo commento');
      }
      if (e.toString().contains('COMMENT_NOT_FOUND')) {
        throw Exception('Commento non trovato');
      }
      rethrow;
    }
  }

  Future<void> voteComment({
    required String commentId,
    required bool isUpvote,
  }) async {
    await _supabase.rpc(
      'vote_comment',
      params: {
        'p_comment_id': commentId,
        'p_is_upvote': isUpvote,
      },
    );
  }
}
