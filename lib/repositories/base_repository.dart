import 'package:incisive/log/main_logger.dart';

abstract class BaseRepository {
  Future<T> guard<T>(
    String action,
    Future<T> Function() body,
  ) async {
    try {
      MainLogger.logInfo(action);
      return await body();
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }
}
