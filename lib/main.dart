import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:incisive/app.dart';
import 'package:incisive/log/app_logger_mobile.dart';
import 'package:incisive/log/app_logger_web.dart';
import 'package:incisive/log/main_logger.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  MainLogger.init(kIsWeb ? WebLogger() : MobileFileLogger());

  FlutterError.onError = MainLogger.logFlutterError;

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const App());
}
