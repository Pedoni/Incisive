import 'package:incisive/source/remote/base_service.dart';
import 'package:incisive/utils/functions.dart';

class GratitudeService extends BaseService {
  Future<JsonObject?> getGratitudePage(DateTime date) async {
    return await guard(
      'Get gratitude page (rpc)',
      () async {
        final res = await supabase.rpc(
          'get_gratitude_page',
          params: {
            'p_user_id': currentUserId,
            'p_date': toSqlDate(date),
          },
        );
        return res as JsonObject?;
      },
    );
  }

  Future<String> _ensurePageExists() async {
    final userId = supabase.auth.currentUser!.id;
    final today = DateTime.now().toIso8601String().substring(0, 10);

    final response =
        await supabase
            .from('gratitude_page')
            .upsert(
              {
                'user_id': userId,
                'date': today,
              },
              onConflict: 'user_id,date',
            )
            .select('id')
            .single();

    return response['id'] as String;
  }

  Future<void> upsertNotes({
    required String? pageId,
    required List<String> texts,
  }) async {
    return await guard("Upsert notes", () async {
      String effectivePageId = pageId ?? await _ensurePageExists();

      await supabase.from('gratitude_note').delete().eq('page_id', effectivePageId);

      if (texts.isEmpty) return;

      final payload = List.generate(
        texts.length,
        (i) => {
          'page_id': effectivePageId,
          'order': i,
          'text': texts[i],
        },
      );

      await supabase.from('gratitude_note').insert(payload);
    });
  }
}
