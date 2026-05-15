import 'package:incisive/source/remote/base_service.dart';
import 'package:incisive/utils/exceptions.dart';
import 'package:incisive/utils/functions.dart';

class DiaryService extends BaseService {
  Future<JsonObject?> getPage({required DateTime date}) async {
    return await guard("Get diary page", () async {
      final sqlDate = toSqlDate(date);

      final page = await supabase.from('diary_page').select('*, is_private').eq('user_id', currentUserId).eq('date', sqlDate).maybeSingle();

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
        'is_private': page['is_private'] as bool? ?? false,
      };
    });
  }

  Future<void> upsertDiaryPage({
    required DateTime date,
    required String text,
  }) async {
    return await guard("Upsert diary page", () async {
      final res = await supabase.functions.invoke(
        'sentiment-analysis',
        body: {
          'date': toSqlDate(date),
          'text': text,
        },
      );

      final data = res.data as JsonObject?;

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
    });
  }

  Future<Map<DateTime, double>> getMood() async {
    return await guard("Get mood", () async {
      final response = await supabase.from('diary_page').select('date, score').eq('user_id', currentUserId).order('date');
      return _extractDateScoreMap(response);
    });
  }

  Future<void> updatePrivacy({
    required DateTime date,
    required bool isPrivate,
  }) async {
    return await guard("Update diary privacy", () async {
      await supabase
          .from('diary_page')
          .update({'is_private': isPrivate})
          .eq('user_id', currentUserId)
          .eq('date', toSqlDate(date));
    });
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
}
