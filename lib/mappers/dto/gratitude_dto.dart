import 'package:incisive/utils/functions.dart';
import 'package:pine/dto/dto.dart';
import 'package:equatable/equatable.dart';

final class GratitudeDTO extends DTO with EquatableMixin {
  final String id;
  final String date;
  final List<String> notes;

  GratitudeDTO.fromJson(JsonObject json)
    : date = json['date'] as String,
      id = json['id'] as String,
      notes = (json['notes'] as List).map((e) => e['text'] as String).toList();

  @override
  List<Object?> get props => [
    id,
    date,
    notes,
  ];
}
