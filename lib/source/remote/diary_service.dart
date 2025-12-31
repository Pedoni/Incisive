import 'package:incisive/utils/functions.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class DiaryService {
  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getPage({
    required DateTime date,
  }) async {
    final userId = _supabase.auth.currentUser!.id;

    final res = await _supabase.from('diary_page').select().eq('user_id', userId).eq('date', toSqlDate(date)).maybeSingle();
    return res;
  }

  Future<void> upsertDiaryPage({
    required DateTime date,
    required String text,
  }) async {
    final supabase = Supabase.instance.client;

    final res = await supabase.functions.invoke(
      'sentiment-analysis',
      body: {
        'date': toSqlDate(date),
        'text': text,
      },
    );

    if (res.data['error'] != null) {
      throw Exception(res.data['reason']);
    }

    final data = res.data as Map<String, dynamic>;

    if (data['ok'] != true) {
      // errori "business" dal server
      throw Exception(data['reason'] ?? data['error'] ?? 'Analisi fallita');
    }
  }

  Map<DateTime, double> _extractDateScoreMap(List<dynamic> rows) {
    final map = <DateTime, double>{};

    for (final row in rows) {
      final date = DateTime.parse(row['date']);
      final score = (row['score'] as num).toDouble();
      map[date] = score;
    }

    return map;
  }

  Future<Map<DateTime, double>?> getMood() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser!.id;

    final response = await supabase.from('diary_page').select().eq('user_id', userId).order('date');

    return _extractDateScoreMap(response);
  }
}
