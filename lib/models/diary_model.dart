class DiaryModel {
  final DateTime date;
  final String text;
  final double score;
  final List<String> emotions;
  final List<String> gratitudeAreas;
  final List<String> nonGratitudeAreas;

  const DiaryModel({
    required this.date,
    required this.text,
    required this.score,
    this.emotions = const [],
    this.gratitudeAreas = const [],
    this.nonGratitudeAreas = const [],
  });
}
