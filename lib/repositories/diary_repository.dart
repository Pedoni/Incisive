import 'package:incisive/log/main_logger.dart';
import 'package:incisive/models/diary_model.dart';
import 'package:incisive/source/remote/diary_service.dart';

class DiaryRepository {
  final DiaryService diaryService;

  DiaryRepository({required this.diaryService});

  Future<DiaryEntry> getPage(DateTime dateTime) async {
    try {
      MainLogger.logInfo("Try to get page");
      final res = await diaryService.getPage(dateTime);
      return DiaryEntry(dateTime, res["text"] as String);
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }
}
