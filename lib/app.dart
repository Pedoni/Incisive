import 'package:flutter/material.dart';
import 'package:incisive_demo/ui/pages/balcony_page.dart';
import 'package:incisive_demo/ui/pages/diary_page.dart';
import 'package:incisive_demo/ui/pages/home_page.dart';
import 'package:incisive_demo/ui/pages/login_page.dart';
import 'package:incisive_demo/ui/pages/turntable_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        home: LoginPage(color: Colors.blue),
        routes: {
          LoginPage.routeName: (context) => LoginPage(color: Colors.blue),
          HomePage.routeName: (context) => const HomePage(),
          DiaryPage.routeName: (context) => const DiaryPage(),
          TurntablePage.routeName: (context) => const TurntablePage(),
          BalconyPage.routeName: (context) => const BalconyPage(),
        },
      ),
    );
  }
}
