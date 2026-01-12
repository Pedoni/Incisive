import 'package:incisive/models/diary_model.dart';
import 'package:incisive/repositories/base_repository.dart';
import 'package:incisive/source/remote/diary_service.dart';

class DiaryRepository extends BaseRepository {
  final DiaryService diaryService;

  DiaryRepository({required this.diaryService});

  /// =========================
  /// GET PAGE
  /// =========================

  Future<DiaryEntry?> getPage(DateTime date) {
    return guard(
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

  /// =========================
  /// UPSERT PAGE
  /// =========================

  Future<void> upsertPage({
    required DateTime date,
    required String text,
  }) {
    return guard(
      'Upsert diary page',
      () => diaryService.upsertDiaryPage(
        date: date,
        text: text,
      ),
    );
  }

  /// =========================
  /// MOOD
  /// =========================

  Future<Map<DateTime, double>> getMood() {
    return guard(
      'Get mood',
      () => diaryService.getMood(),
    );
  }
}
