import 'package:incisive/models/diary_model.dart';

class UpsertDiaryArgs {
  final DateTime date;
  final DiaryModel? entry;

  const UpsertDiaryArgs(this.date, this.entry);
}
