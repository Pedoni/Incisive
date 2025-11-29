import 'package:flutter/material.dart';

class TurntablePage extends StatelessWidget {
  const TurntablePage({super.key});

  static const routeName = '/turntablePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/living.jpeg', fit: BoxFit.cover)),
          Center(
            child: Hero(
              tag: "giradischi",
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  height: 480,
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/turntable.png"), fit: BoxFit.fill)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
