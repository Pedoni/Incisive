import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BreathingDialog extends StatelessWidget {
  final int? points;

  const BreathingDialog({
    this.points,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
      backgroundColor: Colors.white,

      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/cat_happy.png",
            width: 120,
          ),
          const SizedBox(height: 12),
          Text(
            "Ben fatto!",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 25,
              color: Color.fromARGB(255, 60, 60, 60),
            ),
          ),
        ],
      ),

      content: Text(
        'Hai completato l’esercizio di respirazione.\n\n'
        'Ti sei preso un momento per te.',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          height: 1.4,
          color: Color.fromARGB(255, 90, 90, 90),
        ),
      ),

      actionsPadding: const EdgeInsets.only(bottom: 12, right: 12, left: 12),
      actionsAlignment: points != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
      actions: [
        if (points != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "+ $points",
                style: TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontSize: 18,
                ),
              ),
              SizedBox(width: 10),
              Image.asset(
                "assets/icons/leaf.png",
                height: 30,
                width: 30,
              ),
            ],
          ),
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 141, 90, 35),
          ),
          child: const Text(
            'Ok',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
      ],
    );
  }
}
