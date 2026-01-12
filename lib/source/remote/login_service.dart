import 'package:incisive/utils/exceptions.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class LoginService {
  final _supabase = Supabase.instance.client;

  Future<void> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null) {
        throw AuthException("Credenziali errate.");
      }
    } catch (e) {
      if (e is AuthApiException) {
        throw AuthException("Credenziali errate.");
      } else {
        rethrow;
      }
    }
  }

  Future<void> logout() async => await _supabase.auth.signOut();

  Future<void> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw IncisiveException("Errore nella registrazione.");
    }

    final insertRes = await _supabase.from('user').insert({
      'id': user.id,
      'firstName': firstName,
      'lastName': lastName,
      'points': 0,
    });

    if (insertRes != null) {
      throw IncisiveException("Errore creazione profilo utente");
    }
  }

  bool isLogged() => _supabase.auth.currentSession != null;
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
