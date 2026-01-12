import 'package:incisive/utils/exceptions.dart';
import 'package:incisive/utils/functions.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class DiaryService {
  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getPage({
    required DateTime date,
  }) async {
    final userId = _supabase.auth.currentUser!.id;
    final sqlDate = toSqlDate(date);

    final page = await _supabase.from('diary_page').select().eq('user_id', userId).eq('date', sqlDate).maybeSingle();

    if (page == null) return null;

    final emotionRows = await _supabase.from('diary_emotion').select('emotion(name)').eq('diary_user_id', userId).eq('diary_date', sqlDate);

    final emotions = emotionRows.map((e) => e['emotion']['name'] as String).toList();

    final areaRows = await _supabase
        .from('diary_life_area')
        .select('polarity, life_area(name)')
        .eq('diary_user_id', userId)
        .eq('diary_date', sqlDate);

    final gratitudeAreas = <String>[];
    final nonGratitudeAreas = <String>[];

    for (final row in areaRows) {
      final name = row['life_area']['name'] as String;
      if (row['polarity'] == 'positive') {
        gratitudeAreas.add(name);
      } else if (row['polarity'] == 'negative') {
        nonGratitudeAreas.add(name);
      }
    }

    return {
      ...page,
      'emotions': emotions,
      'gratitudeAreas': gratitudeAreas,
      'nonGratitudeAreas': nonGratitudeAreas,
    };
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
      throw IncisiveException(res.data['reason']);
    }

    final data = res.data as Map<String, dynamic>;

    if (data['ok'] != true) {
      // errori "business" dal server
      throw IncisiveException(data['reason'] ?? data['error'] ?? 'Analisi fallita');
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
