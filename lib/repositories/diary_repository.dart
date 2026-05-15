import 'package:incisive/mappers/dto/diary_dto.dart';
import 'package:incisive/models/diary_model.dart';
import 'package:incisive/repositories/base_repository.dart';
import 'package:incisive/source/remote/diary_service.dart';
import 'package:pine/utils/dto_mapper.dart';

class DiaryRepository extends BaseRepository {
  final DiaryService diaryService;
  final DTOMapper<DiaryDTO, DiaryModel> diaryMapper;

  DiaryRepository({
    required this.diaryService,
    required this.diaryMapper,
  });

  Future<DiaryModel?> getPage(DateTime date) async {
    return await guard(
      'Get diary page',
      () async {
        final json = await diaryService.getPage(date: date);
        if (json == null) return null;

        return diaryMapper.fromDTO(DiaryDTO.fromJson(json));
      },
    );
  }

  Future<void> upsertPage({
    required DateTime date,
    required String text,
  }) async {
    return await guard(
      'Upsert diary page',
      () => diaryService.upsertDiaryPage(
        date: date,
        text: text,
      ),
    );
  }

  Future<Map<DateTime, double>> getMood() async {
    return await guard(
      'Get mood',
      () => diaryService.getMood(),
    );
  }

  Future<void> updatePrivacy({
    required DateTime date,
    required bool isPrivate,
  }) async {
    return await guard(
      'Update diary privacy',
      () => diaryService.updatePrivacy(date: date, isPrivate: isPrivate),
    );
  }
}
