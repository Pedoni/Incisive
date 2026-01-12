import 'package:incisive/models/user_model.dart';
import 'package:incisive/source/remote/base_service.dart';

class UserService extends BaseService {
  /// =========================
  /// GET USER PROFILE
  /// =========================

  Future<UserModel> getUser() async {
    final authUser = supabase.auth.currentUser;
    if (authUser == null) {
      throw Exception('Utente non autenticato');
    }

    final user = await supabase.from('user').select().eq('id', authUser.id).single();

    return UserModel(
      id: authUser.id,
      firstName: user['firstName'],
      lastName: user['lastName'],
      email: authUser.email!,
      points: user['points'],
    );
  }

  /// =========================
  /// ADD POINTS
  /// =========================

  Future<void> addPoints({
    required int points,
  }) async {
    await supabase.rpc(
      'add_points',
      params: {
        'p_user_id': currentUserId,
        'p_points': points,
      },
    );
  }
}
