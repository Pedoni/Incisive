import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class DiaryService {
  Future<Map<String, dynamic>?> getPage({
    required String userId,
    required DateTime date,
  }) async {
    final supabase = Supabase.instance.client;

    final response =
        await supabase
            .from('diary_page')
            .select()
            .eq(
              'user_id',
              userId,
            )
            .eq(
              'date',
              date.toIso8601String().substring(0, 10),
            )
            .maybeSingle();

    return response;
  }
}
