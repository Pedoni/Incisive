import 'package:incisive/log/main_logger.dart';
import 'package:incisive/models/diary_model.dart';
import 'package:incisive/source/remote/diary_service.dart';

class DiaryRepository {
  final DiaryService diaryService;

  DiaryRepository({required this.diaryService});

  Future<DiaryEntry?> getPage(DateTime dateTime) async {
    try {
      MainLogger.logInfo("Try to get page");

      final res = await diaryService.getPage(date: dateTime);
      if (res == null) return null;

      return DiaryEntry(
        date: dateTime,
        text: res['text'] as String,
        score: (res['score'] as num).toDouble(),
        emotions: List<String>.from(res['emotions'] as List),
        gratitudeAreas: List<String>.from(res['gratitudeAreas'] as List),
        nonGratitudeAreas: List<String>.from(res['nonGratitudeAreas'] as List),
      );
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> upsertPage({
    required DateTime date,
    required String text,
  }) async {
    try {
      MainLogger.logInfo("Try to upsert page");
      await diaryService.upsertDiaryPage(text: text, date: date);
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<Map<DateTime, double>?> getMood() async {
    try {
      MainLogger.logInfo("Try to get mood");
      return await diaryService.getMood();
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }
}
