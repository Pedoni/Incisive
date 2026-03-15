import 'package:flutter/material.dart';
import 'package:incisive/ui/widgets/base_app_dialog.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String text;

  const ErrorDialog({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return BaseAppDialog(
      imagePath: 'assets/images/cat_doubt.png',
      title: title,
      content: text,
    );
  }
}