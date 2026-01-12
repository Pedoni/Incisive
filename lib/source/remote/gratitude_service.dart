import 'package:incisive/source/remote/base_service.dart';
import 'package:incisive/utils/functions.dart';

class GratitudeService extends BaseService {
  /// =========================
  /// GET / CREATE PAGE
  /// =========================

  Future<Map<String, dynamic>> getPage({
    required DateTime date,
  }) async {
    final dateSql = toSqlDate(date);

    final page = await supabase.from('gratitude_page').select().eq('user_id', currentUserId).eq('date', dateSql).maybeSingle();

    if (page != null) {
      return page;
    }

    final inserted =
        await supabase
            .from('gratitude_page')
            .insert({
              'user_id': currentUserId,
              'date': dateSql,
            })
            .select()
            .single();

    return inserted;
  }

  /// =========================
  /// GET NOTES
  /// =========================

  Future<List<Map<String, dynamic>>?> getNotes({
    required String pageId,
  }) async {
    final notes = await supabase.from('gratitude_note').select().eq('page_id', pageId).order('order');

    if (notes.isEmpty) return null;

    return List<Map<String, dynamic>>.from(notes);
  }

  /// =========================
  /// UPSERT NOTES
  /// =========================

  Future<void> upsertNotes({
    required String pageId,
    required List<String> texts,
  }) async {
    // remove existing notes
    await supabase.from('gratitude_note').delete().eq('page_id', pageId);

    if (texts.isEmpty) return;

    final payload = List.generate(
      texts.length,
      (i) => {
        'page_id': pageId,
        'order': i,
        'text': texts[i],
      },
    );

    await supabase.from('gratitude_note').insert(payload);
  }
}
