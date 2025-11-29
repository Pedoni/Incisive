import 'package:flutter/material.dart';
import 'package:incisive/app.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://hktlznvzeixqyisnegzr.supabase.co',
    anonKey: 'sb_publishable_UN7xRZjEEHrYjF87juF3iA_MnL8izcu',
  );
  runApp(const App());
}

final supabase = Supabase.instance.client;
