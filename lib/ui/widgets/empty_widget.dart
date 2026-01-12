import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyWidget extends StatelessWidget {
  final String text;

  const EmptyWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            "assets/animations/empty_state.json",
            width: 200,
            height: 200,
            repeat: false,
          ),
          const SizedBox(height: 24),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
