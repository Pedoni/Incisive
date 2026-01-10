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
}
