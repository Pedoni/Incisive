import 'package:incisive/source/remote/base_service.dart';

class BreathingService extends BaseService {
  Future<int> completeBreathing() async {
    return await guard("Complete breathing", () async {
      final result = await supabase.rpc('complete_breathing');
      return result as int;
    });
  }
}
