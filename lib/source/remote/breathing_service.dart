import 'package:incisive/source/remote/base_service.dart';

class BreathingService extends BaseService {
  Future<int> completeBreathing() async {
    try {
      final result = await supabase.rpc('complete_breathing');
      return result as int;
    } catch (e) {
      throw Exception('Errore nel completare la sessione di respirazione');
    }
  }
}
