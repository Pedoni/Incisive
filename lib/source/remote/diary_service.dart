import 'package:incisive/utils/functions.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class DiaryService {
  Future<Map<String, dynamic>?> getPage({required DateTime date}) async {
    final supabase = Supabase.instance.client;

    final userId = supabase.auth.currentUser!.id;

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

  Future<void> upsertDiaryPage({
    required DateTime date,
    required String text,
  }) async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser!.id;

    final response = await supabase.functions.invoke(
      'sentiment-analysis',
      body: {'text': text},
    );

    if (response.data['sentiment'] == "unknown") {
      throw Exception(response.data['reason']);
    }

    if (response.data['error'] != null) {
      throw Exception(response.data['error']);
    }

    await supabase.from('diary_page').upsert({
      'user_id': userId,
      'date': toSqlDate(date),
      'text': text,
      'score': (response.data['score'] as num).toDouble(),
    });
  }
}
