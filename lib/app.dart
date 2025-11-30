import 'package:flutter/material.dart';
import 'package:incisive/di/dependency_injector.dart';
import 'package:incisive/ui/pages/diary_page.dart';
import 'package:incisive/ui/pages/home_page.dart';
import 'package:incisive/ui/pages/login_page.dart';
import 'package:incisive/ui/pages/register_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DependencyInjector(
      child: MaterialApp(
        title: 'Incisive',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        home: LoginPage(),
        routes: {
          LoginPage.routeName: (context) => LoginPage(),
          RegisterPage.routeName: (context) => RegisterPage(),
          HomePage.routeName: (context) => const HomePage(),
          DiaryPage.routeName: (context) => const DiaryPage(),
        },
      ),
    );
  }
}
