import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class BreathingService {
  final _supabase = Supabase.instance.client;

  Future<int> completeBreathing() async {
    final result = await _supabase.rpc('complete_breathing');
    return result as int;
  }
}
