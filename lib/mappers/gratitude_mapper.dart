import 'package:incisive/mappers/dto/gratitude_dto.dart';
import 'package:incisive/models/gratitude_page_model.dart';
import 'package:pine/utils/dto_mapper.dart';

class GratitudeMapper extends DTOMapper<GratitudeDTO, GratitudePageModel> {
  @override
  GratitudePageModel fromDTO(GratitudeDTO dto) {
    return GratitudePageModel(
      date: DateTime.parse(dto.date),
      id: dto.id,
      list: dto.notes,
    );
  }

  @override
  GratitudeDTO toDTO(GratitudePageModel model) {
    throw UnimplementedError();
  }
}
