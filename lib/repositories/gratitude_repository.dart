import 'package:incisive/models/gratitude_page_model.dart';
import 'package:incisive/repositories/base_repository.dart';
import 'package:incisive/source/remote/gratitude_service.dart';

class GratitudeRepository extends BaseRepository {
  final GratitudeService gratitudeService;

  GratitudeRepository({required this.gratitudeService});

  Future<GratitudePageModel> getPage(DateTime date) async {
    return await guard(
      'Get gratitude page',
      () async {
        final page = await gratitudeService.getPage(date: date);
        final notes = await gratitudeService.getNotes(pageId: page['id']);

        return GratitudePageModel(
          id: page['id'] as String,
          date: date,
          list: notes == null ? [] : notes.map((e) => e['text'] as String).toList(),
        );
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
