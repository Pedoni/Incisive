import 'package:incisive/main.dart';
import 'package:supabase/supabase.dart';

class LoginService {
  Future<void> login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
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

  Future<void> logout() async => await supabase.auth.signOut();

  Future<void> register(String email, String password) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception("Errore nella registrazione.");
    }
  }

  bool isLogged() => supabase.auth.currentSession != null;
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
