import 'package:incisive/mappers/dto/diary_dto.dart';
import 'package:incisive/models/diary_model.dart';
import 'package:pine/utils/dto_mapper.dart';

class DiaryMapper extends DTOMapper<DiaryDTO, DiaryModel> {
  @override
  DiaryModel fromDTO(DiaryDTO dto) {
    return DiaryModel(
      date: DateTime.parse(dto.date),
      score: dto.score,
      text: dto.text,
      emotions: dto.emotions,
      gratitudeAreas: dto.gratitudeAreas,
      nonGratitudeAreas: dto.nonGratitudeAreas,
      isPrivate: dto.isPrivate,
    );
  }

  @override
  DiaryDTO toDTO(DiaryModel model) {
    throw UnimplementedError();
  }
}
