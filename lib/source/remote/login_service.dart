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

  Future<void> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw Exception("Errore nella registrazione.");
    }

    final insertRes = await supabase.from('user').insert({
      'id': user.id,
      'firstName': firstName,
      'lastName': lastName,
      'points': 0,
    });

    if (insertRes != null) {
      throw Exception("Errore creazione profilo utente");
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
