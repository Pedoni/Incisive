import 'package:incisive/main.dart';

class LoginService {
  Future<void> login(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.session == null) {
      throw Exception("Credenziali sbagliate");
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  Future<void> signUp(String email, String password) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception("Errore nella registrazione");
    }
  }

  bool isLogged() {
    final session = supabase.auth.currentSession;
    return session != null;
  }
}
