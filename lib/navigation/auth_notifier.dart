import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class AuthNotifier extends ChangeNotifier {
  late final StreamSubscription<AuthState> _sub;

  AuthNotifier() {
    _sub = Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
