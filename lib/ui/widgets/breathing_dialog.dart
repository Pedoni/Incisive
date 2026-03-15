import 'package:flutter/material.dart';
import 'package:incisive/ui/widgets/base_app_dialog.dart';

class BreathingDialog extends StatelessWidget {
  final int? points;

  const BreathingDialog({
    this.points,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BaseAppDialog(
      imagePath: 'assets/images/cat_happy.png',
      title: 'Ben fatto!',
      content: "Hai completato l'esercizio di respirazione.\n\nTi sei preso un momento per te.",
      points: points,
    );
  }
}