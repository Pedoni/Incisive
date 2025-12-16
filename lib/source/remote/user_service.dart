import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class UserService {
  Future<User?> getUser() async {
    final supabase = Supabase.instance.client;
    return supabase.auth.currentUser;
  }
}
