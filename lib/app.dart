import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:incisive/di/dependency_injector.dart';
import 'package:incisive/navigation/app_router.dart';
import 'package:incisive/navigation/auth_notifier.dart';
import 'package:incisive/utils/incisive_colors.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthNotifier _authNotifier;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authNotifier = AuthNotifier();
    _router = createRouter(_authNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return DependencyInjector(
      child: MaterialApp.router(
        title: 'Incisive',
        debugShowCheckedModeBanner: false,
        localeResolutionCallback: (locale, supportedLocales) {
          if (locale == null) return supportedLocales.first;
          for (final l in supportedLocales) {
            if (l.languageCode == locale.languageCode) {
              return l;
            }
          }
          return supportedLocales.first;
        },
        routerConfig: _router,
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
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: IncisiveColors.primary)),
      ),
    );
  }

  @override
  void dispose() {
    _authNotifier.dispose();
    super.dispose();
  }
}
