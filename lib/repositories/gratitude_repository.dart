import 'package:incisive/log/main_logger.dart';
import 'package:incisive/models/gratitude_page_model.dart';
import 'package:incisive/source/remote/gratitude_service.dart';

class GratitudeRepository {
  final GratitudeService gratitudeService;

  GratitudeRepository({required this.gratitudeService});

  Future<GratitudePageModel?> getPage(DateTime dateTime) async {
    try {
      MainLogger.logInfo("Try to get page");
      final res = await gratitudeService.getPage(date: dateTime);
      return res != null
          ? GratitudePageModel(
            date: dateTime,
            list: (res["list"] as List<dynamic>).map((e) => e.toString()).toList(),
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
      await gratitudeService.upsertPage(text: text, date: date);
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }
}
