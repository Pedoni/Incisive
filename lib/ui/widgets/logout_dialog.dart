import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/cat_doubt.png",
            width: 120,
          ),
        ],
      ),
      content: const Text(
        "Vuoi davvero effettuare il logout? Dovrai effettuare nuovamente il login per accedere al tuo account.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          height: 1.4,
          color: Color.fromARGB(255, 90, 90, 90),
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            foregroundColor: const Color.fromARGB(255, 141, 90, 35),
            backgroundColor: const Color.fromARGB(255, 244, 223, 200),
          ),
          child: const Text(
            'Annulla',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),

        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
