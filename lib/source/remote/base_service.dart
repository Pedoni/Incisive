import 'package:supabase_auth_ui/supabase_auth_ui.dart';

abstract class BaseService {
  SupabaseClient get supabase => Supabase.instance.client;

  String get currentUserId {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user.id;
  }

  Never handleError(Object e) {
    throw Exception(e.toString());
  }
}
