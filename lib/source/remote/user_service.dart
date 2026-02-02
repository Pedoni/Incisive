import 'package:incisive/source/remote/base_service.dart';
import 'package:incisive/utils/exceptions.dart';
import 'package:incisive/utils/functions.dart';

class UserService extends BaseService {
  Future<JsonObject> getUserWithProgress() async {
    return await guard(
      "Get user with progress",
      () async {
        final authUser = supabase.auth.currentUser;
        if (authUser == null) {
          throw IncisiveException('Utente non autenticato');
        }

        final userJson = await supabase.from('user').select().eq('id', authUser.id).single();

        final progressJson =
            await supabase.rpc(
                  'get_user_progress',
                  params: {'p_user_id': authUser.id},
                )
                as JsonObject;

        return {
          ...userJson,
          ...progressJson,
          'email': authUser.email,
        };
      },
    );
  }

  Future<void> addPoints({required int points}) async {
    return await guard(
      "Add points",
      () async => await supabase.rpc(
        'add_points',
        params: {
          'p_user_id': currentUserId,
          'p_points': points,
        },
      ),
    );
  }

  Future<JsonArray> getAvatars() async {
    return await guard(
      "Get avatars",
      () async {
        final avatars = await supabase.from('avatar').select();

        final userAvatars = await supabase.from('user_avatar').select().eq('user_id', currentUserId);

        final ownedMap = {
          for (final ua in userAvatars) ua['avatar_id']: ua,
        };

        return avatars.map((avatar) {
          final owned = ownedMap[avatar['id']];
          return {
            ...avatar,
            'owned': owned != null,
            'equipped': owned?['equipped'] ?? false,
          };
        }).toList();
      },
    );
  }

  Future<void> purchaseAvatar(String avatarId) async {
    await guard(
      "Purchase avatar",
      () => supabase.rpc(
        'purchase_avatar',
        params: {
          'p_user_id': currentUserId,
          'p_avatar_id': avatarId,
        },
      ),
    );
  }

  Future<void> equipAvatar(String avatarId) async {
    await guard(
      "Equip avatar",
      () => supabase.rpc(
        'equip_avatar',
        params: {
          'p_user_id': currentUserId,
          'p_avatar_id': avatarId,
        },
      ),
    );
  }
}
