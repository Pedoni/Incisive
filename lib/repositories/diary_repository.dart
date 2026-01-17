import 'package:incisive/models/diary_model.dart';
import 'package:incisive/repositories/base_repository.dart';
import 'package:incisive/source/remote/diary_service.dart';

class DiaryRepository extends BaseRepository {
  final DiaryService diaryService;

  DiaryRepository({required this.diaryService});

  Future<DiaryEntry?> getPage(DateTime date) async {
    return await guard(
      'Get diary page',
      () async {
        final res = await diaryService.getPage(date: date);
        if (res == null) return null;

        return DiaryEntry(
          date: date,
          text: res['text'] as String,
          score: (res['score'] as num).toDouble(),
          emotions: List<String>.from(res['emotions'] as List),
          gratitudeAreas: List<String>.from(res['gratitudeAreas'] as List),
          nonGratitudeAreas: List<String>.from(res['nonGratitudeAreas'] as List),
        );
      },
    );
  }

  Future<void> upsertPage({
    required DateTime date,
    required String text,
  }) async {
    return await guard(
      'Upsert diary page',
      () => diaryService.upsertDiaryPage(
        date: date,
        text: text,
      ),
    );
  }

  Future<Map<DateTime, double>> getMood() async {
    return await guard(
      'Get mood',
      () => diaryService.getMood(),
    );
  }
}
