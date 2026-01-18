import 'package:incisive/mappers/dto/gratitude_dto.dart';
import 'package:incisive/models/gratitude_page_model.dart';
import 'package:incisive/repositories/base_repository.dart';
import 'package:incisive/source/remote/gratitude_service.dart';
import 'package:pine/utils/dto_mapper.dart';

class GratitudeRepository extends BaseRepository {
  final GratitudeService gratitudeService;
  final DTOMapper<GratitudeDTO, GratitudePageModel> gratitudeMapper;

  GratitudeRepository({
    required this.gratitudeService,
    required this.gratitudeMapper,
  });

  Future<GratitudePageModel?> getPage(DateTime date) async {
    return await guard(
      'Get gratitude page',
      () async {
        final json = await gratitudeService.getGratitudePage(date);
        if (json == null) return null;
        return gratitudeMapper.fromDTO(GratitudeDTO.fromJson(json));
      },
    );
  }

  Future<void> upsertPage({
    required String pageId,
    required List<String> texts,
  }) async {
    return await guard(
      'Upsert gratitude page',
      () => gratitudeService.upsertNotes(
        pageId: pageId,
        texts: texts,
      ),
    );
  }
}
