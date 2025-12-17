import 'package:incisive/log/main_logger.dart';
import 'package:incisive/models/gratitude_page_model.dart';
import 'package:incisive/source/remote/gratitude_service.dart';

class GratitudeRepository {
  final GratitudeService gratitudeService;

  GratitudeRepository({required this.gratitudeService});

  Future<GratitudePageModel?> getPage(DateTime dateTime) async {
    try {
      MainLogger.logInfo("Try to get page");
      final page = await gratitudeService.getPage(date: dateTime);
      final notes = await gratitudeService.getNotes(pageId: page['id']);
      return GratitudePageModel(
        date: dateTime,
        list: notes == null ? [] : (notes as List<dynamic>).map((e) => e["text"] as String).toList(),
      );
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> upsertPage({
    required String pageId,
    required List<String> texts,
  }) async {
    try {
      MainLogger.logInfo("Try to upsert page");
      await gratitudeService.upsertNotes(pageId: pageId, texts: texts);
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }
}
