import 'package:incisive/log/main_logger.dart';
import 'package:incisive/source/remote/breathing_service.dart';

class BreathingRepository {
  final BreathingService breathingService;

  BreathingRepository({required this.breathingService});

  Future<int> completeBreathing() async {
    try {
      MainLogger.logInfo("Try to complete breathing");
      return await breathingService.completeBreathing();
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }
}
