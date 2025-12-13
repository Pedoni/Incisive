import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:incisive/di/dependency_injector.dart';
import 'package:incisive/models/diary_model.dart';
import 'package:incisive/ui/pages/diary_page.dart';
import 'package:incisive/ui/pages/diary_upsert_page.dart';
import 'package:incisive/ui/pages/home_page.dart';
import 'package:incisive/ui/pages/login_page.dart';
import 'package:incisive/ui/pages/mood_calendar_page.dart';
import 'package:incisive/ui/pages/register_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DependencyInjector(
      child: SafeArea(
        child: MaterialApp(
          title: 'Incisive',
          debugShowCheckedModeBanner: false,
          localeResolutionCallback: (locale, supportedLocales) {
            return locale;
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/upsertDiaryPage') {
              final list = settings.arguments as List<dynamic>;
              final selectedDate = list[0] as DateTime;
              final entry = list[1] as DiaryEntry?;
              return MaterialPageRoute(
                builder:
                    (_) => UpsertDiaryPage(
                      date: selectedDate,
                      existingEntry: entry,
                    ),
              );
            }
            return null;
          },
          supportedLocales: const [
            Locale('it'),
            Locale('en'),
            Locale('es'),
            Locale('fr'),
            Locale('de'),
          ],

          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 141, 90, 35))),
          home: LoginPage(),
          routes: {
            LoginPage.routeName: (context) => LoginPage(),
            RegisterPage.routeName: (context) => RegisterPage(),
            HomePage.routeName: (context) => const HomePage(),
            DiaryPage.routeName: (context) => const DiaryPage(),
            MoodCalendarPage.routeName: (context) => MoodCalendarPage(),
          },
        ),
      ),
    );
  }
}
