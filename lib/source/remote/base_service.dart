import 'package:incisive/log/main_logger.dart';
import 'package:incisive/utils/exceptions.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

abstract class BaseService {
  SupabaseClient get supabase => Supabase.instance.client;

  String get currentUserId {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw IncisiveException('User not authenticated');
    }
    return user.id;
  }

  Future<T> guard<T>(
    String action,
    Future<T> Function() body,
  ) async {
    try {
      MainLogger.logInfo(action);
      return await body();
    } catch (e, stackTrace) {
      MainLogger.logError(e, stackTrace);
      rethrow;
    }
  }
}
