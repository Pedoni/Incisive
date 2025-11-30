import 'package:flutter/material.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  static const routeName = '/diaryPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: "diario",
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              height: 480,
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/diary.png"), fit: BoxFit.fill)),
            ),
          ),
        ),
      ),
    );
  }
}
