import 'package:incisive/source/remote/base_service.dart';
import 'package:incisive/utils/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginService extends BaseService {
  /// =========================
  /// LOGIN
  /// =========================

  Future<void> login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null) {
        throw IncisiveException('Credenziali errate.');
      }
    } on AuthApiException {
      throw IncisiveException('Credenziali errate.');
    } catch (_) {
      throw IncisiveException('Errore durante il login.');
    }
  }

  /// =========================
  /// LOGOUT
  /// =========================

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  /// =========================
  /// REGISTER
  /// =========================

  Future<void> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw IncisiveException('Errore nella registrazione.');
      }

      await supabase.from('user').insert({
        'id': user.id,
        'firstName': firstName,
        'lastName': lastName,
        'points': 0,
      });
    } on AuthApiException catch (e) {
      throw IncisiveException(e.message);
    } catch (_) {
      throw IncisiveException('Errore creazione profilo utente.');
    }
  }

  /// =========================
  /// SESSION
  /// =========================

  bool isLogged() => supabase.auth.currentSession != null;
}
