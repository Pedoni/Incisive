import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:incisive/di/dependency_injector.dart';
import 'package:incisive/navigation/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DependencyInjector(
      child: MaterialApp.router(
        title: 'Incisive',
        debugShowCheckedModeBanner: false,
        localeResolutionCallback: (locale, supportedLocales) {
          return locale;
        },
        routerConfig: appRouter,
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
      ),
    );
  }
}
