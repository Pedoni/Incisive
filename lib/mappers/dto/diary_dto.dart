import 'package:incisive/utils/functions.dart';
import 'package:pine/dto/dto.dart';
import 'package:equatable/equatable.dart';

final class DiaryDTO extends DTO with EquatableMixin {
  final String date;
  final String text;
  final double score;
  final List<String> emotions;
  final List<String> gratitudeAreas;
  final List<String> nonGratitudeAreas;
  final bool isPrivate;

  DiaryDTO.fromJson(JsonObject json)
    : date = json['date'] as String,
      text = json['text'] as String,
      score = (json['score'] as num).toDouble(),
      emotions = List<String>.from(json['emotions'] as List),
      gratitudeAreas = List<String>.from(json['gratitudeAreas'] as List),
      nonGratitudeAreas = List<String>.from(json['nonGratitudeAreas'] as List),
      isPrivate = json['is_private'] as bool? ?? false;

  @override
  List<Object?> get props => [
    date,
    text,
    score,
    emotions,
    gratitudeAreas,
    nonGratitudeAreas,
    isPrivate,
  ];
}
