import 'package:incisive/models/user_model.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class UserService {
  final _supabase = Supabase.instance.client;

  Future<UserModel> getUser() async {
    final authUser = _supabase.auth.currentUser;
    final userId = authUser!.id;
    final user = await _supabase.from('user').select().eq('id', userId).maybeSingle();
    return UserModel(
      id: userId,
      firstName: user!['firstName'],
      lastName: user['lastName'],
      email: authUser.email!,
      points: user['points'],
    );
  }

  Future<void> addPoints({required int points}) async {
    try {
      await _supabase.rpc(
        'add_points',
        params: {
          'p_user_id': _supabase.auth.currentUser!.id,
          'p_points': points,
        },
      );
    } on PostgrestException catch (_) {
      rethrow;
    }
  }
}
