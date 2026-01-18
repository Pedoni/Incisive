import 'package:incisive/mappers/dto/gratitude_dto.dart';
import 'package:incisive/models/gratitude_model.dart';
import 'package:pine/utils/dto_mapper.dart';

class GratitudeMapper extends DTOMapper<GratitudeDTO, GratitudeModel> {
  @override
  GratitudeModel fromDTO(GratitudeDTO dto) {
    return GratitudeModel(
      date: DateTime.parse(dto.date),
      id: dto.id,
      list: dto.notes,
    );
  }

  @override
  GratitudeDTO toDTO(GratitudeModel model) {
    throw UnimplementedError();
  }
}
