class DiaryModel {
  final DateTime date;
  final String text;
  final double score;
  final List<String> emotions;
  final List<String> gratitudeAreas;
  final List<String> nonGratitudeAreas;
  final bool isPrivate;

  const DiaryModel({
    required this.date,
    required this.text,
    required this.score,
    this.emotions = const [],
    this.gratitudeAreas = const [],
    this.nonGratitudeAreas = const [],
    this.isPrivate = false,
  });


  DiaryModel copyWith({bool? isPrivate}) {
      return DiaryModel(
        date: date,
        text: text,
        score: score,
        emotions: emotions,
        gratitudeAreas: gratitudeAreas,
        nonGratitudeAreas: nonGratitudeAreas,
        isPrivate: isPrivate ?? this.isPrivate,
      );
  }
}