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
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: [Text(text)],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Ok'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
