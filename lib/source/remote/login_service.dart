import 'package:incisive/source/remote/base_service.dart';
import 'package:incisive/utils/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginService extends BaseService {
  Future<void> login(
    String email,
    String password,
  ) async {
    return await guard("Login", () async {
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
      } catch (e) {
        throw IncisiveException('Errore durante il login.');
      }
    });
  }

  Future<void> logout() async {
    return await guard("Logout", () async {
      await supabase.auth.signOut();
    });
  }

  Future<void> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    return await guard("Register", () async {
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
      } on AuthWeakPasswordException catch (_) {
        throw IncisiveException("La password deve contenere almeno 6 caratteri.");
      } catch (e) {
        throw IncisiveException('Errore creazione profilo utente.');
      }
    });
  }

  bool isLogged() => supabase.auth.currentSession != null;
}
