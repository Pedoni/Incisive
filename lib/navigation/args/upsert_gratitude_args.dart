import 'package:incisive/models/gratitude_page_model.dart';

class UpsertGratitudeArgs {
  final DateTime date;
  final GratitudePageModel? page;

  const UpsertGratitudeArgs({
    required this.date,
    this.page,
  });
}
