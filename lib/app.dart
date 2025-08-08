import 'package:flutter/material.dart';
import 'package:incisive_demo/ui/pages/home_page.dart';
import 'package:incisive_demo/ui/pages/login_page.dart';

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
        routes: {LoginPage.routeName: (context) => LoginPage(color: Colors.blue), HomePage.routeName: (context) => const HomePage()},
      ),
    );
  }
}
