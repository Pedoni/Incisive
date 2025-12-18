import 'package:incisive/utils/functions.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class GratitudeService {
  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> getPage({required DateTime date}) async {
    final userId = _supabase.auth.currentUser!.id;
    final dateSql = toSqlDate(date);

    final page = await _supabase.from('gratitude_page').select().eq('user_id', userId).eq('date', dateSql).maybeSingle();
    if (page != null) {
      return page;
    }

    final inserted =
        await _supabase
            .from('gratitude_page')
            .insert({
              'user_id': userId,
              'date': dateSql,
            })
            .select()
            .single();

    return inserted;
  }

  Future<List<Map<String, dynamic>>?> getNotes({required String pageId}) async {
    final notes = await _supabase.from('gratitude_note').select().eq('page_id', pageId).order('order');
    return notes.isEmpty ? null : List<Map<String, dynamic>>.from(notes);
  }

  Future<void> upsertNote({
    required String pageId,
    required int order,
    required String text,
  }) async {
    await _supabase.from('gratitude_note').upsert({
      'page_id': pageId,
      'order': order,
      'text': text,
    });
  }

  Future<void> upsertNotes({
    required String pageId,
    required List<String> texts,
  }) async {
    if (texts.isEmpty) return;

    final payload = <Map<String, dynamic>>[];

    for (int i = 0; i < texts.length; i++) {
      payload.add({
        'page_id': pageId,
        'order': i,
        'text': texts[i],
      });
    }

    await _supabase.from('gratitude_note').upsert(payload);
  }
}
