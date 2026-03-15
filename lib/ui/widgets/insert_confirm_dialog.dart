import 'package:flutter/material.dart';
import 'package:incisive/ui/widgets/base_app_dialog.dart';
import 'package:incisive/utils/enums.dart';

class InsertConfirmDialog extends StatelessWidget {
  final PostType type;
  final int? points;

  const InsertConfirmDialog({
    required this.type,
    this.points,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final title = switch (type) {
      PostType.post => 'Creato!',
      PostType.gdEdit => 'Modificato!',
      PostType.gdInsert => 'Inserito!',
      PostType.comment => 'Inviato!',
    };
    final body = switch (type) {
      PostType.post => 'Post creato',
      PostType.gdEdit => 'Modifica avvenuta',
      PostType.gdInsert => 'Inserimento avvenuto',
      PostType.comment => 'Commento inviato',
    };
    return BaseAppDialog(
      imagePath: 'assets/images/cat_happy.png',
      title: title,
      content: '$body con successo.',
      points: points,
    );
  }
}
