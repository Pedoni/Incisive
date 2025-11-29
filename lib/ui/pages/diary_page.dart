import 'package:flutter/material.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  static const routeName = '/diaryPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/bedroom.jpeg', fit: BoxFit.cover)),
          Center(
            child: Hero(
              tag: "diario",
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  height: 480,
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/diary.png"), fit: BoxFit.fill)),
                  child: TextField(
                    maxLines: null,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration.collapsed(hintText: "Scrivi qui..."),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
