import 'package:incisive/log/main_logger.dart';
import 'package:incisive/main.dart';
import 'package:incisive/models/diary_model.dart';
import 'package:incisive/source/remote/diary_service.dart';

class DiaryRepository {
  final DiaryService diaryService;

  DiaryRepository({required this.diaryService});

  Future<DiaryEntry?> getPage(DateTime dateTime) async {
    try {
      MainLogger.logInfo("Try to get page");
      final userId = supabase.auth.currentUser!.id;
      final res = await diaryService.getPage(userId: userId, date: dateTime);
      return res != null
          ? DiaryEntry(
            dateTime,
            res["text"] as String,
            res["score"] as double,
          )
          : null;
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }
}
