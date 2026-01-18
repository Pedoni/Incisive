import 'package:incisive/models/gratitude_model.dart';

class UpsertGratitudeArgs {
  final DateTime date;
  final GratitudeModel? page;

  const UpsertGratitudeArgs({
    required this.date,
    this.page,
  });
}
