import 'package:flutter/material.dart';

class BalconyPage extends StatelessWidget {
  const BalconyPage({super.key});

  static const routeName = '/balconyPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/balcony.jpeg', fit: BoxFit.cover)),
          Center(
            child: Hero(
              tag: "piantina",
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  height: 480,
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/piantina.png"), fit: BoxFit.fill)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
