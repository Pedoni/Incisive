import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String text;

  const ErrorDialog({
    required this.title,
    required this.text,
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
      title: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Color.fromARGB(255, 200, 80, 80),
            size: 28,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color.fromARGB(255, 60, 60, 60),
              ),
            ),
          ),
        ],
      ),
      content: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          height: 1.4,
          color: Color.fromARGB(255, 90, 90, 90),
        ),
      ),
      actionsPadding: const EdgeInsets.only(bottom: 12, right: 12),
      actions: [
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
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
