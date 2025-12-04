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
      return res != null
          ? DiaryEntry(
            dateTime,
            res["text"] as String,
            (res["score"] as num).toDouble(),
          )
          : null;
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
}
