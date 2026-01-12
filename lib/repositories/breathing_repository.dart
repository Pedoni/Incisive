import 'package:incisive/repositories/base_repository.dart';
import 'package:incisive/source/remote/breathing_service.dart';

class BreathingRepository extends BaseRepository {
  final BreathingService breathingService;

  BreathingRepository({required this.breathingService});

  Future<int> completeBreathing() {
    return guard(
      'Complete breathing session',
      () => breathingService.completeBreathing(),
    );
  }
}
