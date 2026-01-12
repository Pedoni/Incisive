import 'package:incisive/source/remote/base_service.dart';
import 'package:incisive/utils/exceptions.dart';
import 'package:incisive/utils/functions.dart';

class DiaryService extends BaseService {
  /// =========================
  /// GET PAGE
  /// =========================

  Future<Map<String, dynamic>?> getPage({
    required DateTime date,
  }) async {
    final sqlDate = toSqlDate(date);

    final page = await supabase.from('diary_page').select().eq('user_id', currentUserId).eq('date', sqlDate).maybeSingle();

    if (page == null) return null;

    final emotionRows = await supabase
        .from('diary_emotion')
        .select('emotion(name)')
        .eq('diary_user_id', currentUserId)
        .eq('diary_date', sqlDate);

    final emotions = emotionRows.map((e) => e['emotion']['name'] as String).toList();

    final areaRows = await supabase
        .from('diary_life_area')
        .select('polarity, life_area(name)')
        .eq('diary_user_id', currentUserId)
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

  /// =========================
  /// UPSERT PAGE (sentiment)
  /// =========================

  Future<void> upsertDiaryPage({
    required DateTime date,
    required String text,
  }) async {
    final res = await supabase.functions.invoke(
      'sentiment-analysis',
      body: {
        'date': toSqlDate(date),
        'text': text,
      },
    );

    final data = res.data as Map<String, dynamic>?;

    if (data == null) {
      throw IncisiveException('Risposta non valida dal server');
    }

    if (data['error'] != null) {
      throw IncisiveException(data['reason']);
    }

    if (data['ok'] != true) {
      throw IncisiveException(
        data['reason'] ?? data['error'] ?? 'Analisi fallita',
      );
    }
  }

  /// =========================
  /// MOOD TRACKER
  /// =========================

  Future<Map<DateTime, double>> getMood() async {
    final response = await supabase.from('diary_page').select('date, score').eq('user_id', currentUserId).order('date');

    return _extractDateScoreMap(response);
  }

  /// =========================
  /// PRIVATE
  /// =========================

  Map<DateTime, double> _extractDateScoreMap(List<dynamic> rows) {
    final map = <DateTime, double>{};

    for (final row in rows) {
      final date = DateTime.parse(row['date']);
      final score = (row['score'] as num).toDouble();
      map[date] = score;
    }

    return map;
  }
}
