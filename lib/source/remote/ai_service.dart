import 'package:incisive/models/ai_preferences_model.dart';
import 'package:incisive/source/remote/base_service.dart';
import 'package:incisive/utils/functions.dart';

// legge le preferenze AI dalla tabella user_preferences.
class AiService extends BaseService {

  Future<AiPreferencesModel> getPreferences() async {
    return await guard('Get AI preferences', () async {
      final data = await supabase
          .from('user_preferences')
          .select('assistant_style, main_goal, conversation_style, error_reaction')
          .eq('user_id', currentUserId)
          .maybeSingle();

      if (data == null) return const AiPreferencesModel.defaults();
      return AiPreferencesModel.fromJson(data);
    });
  }

  Future<List<JsonObject>> getRecentDiaryEntries({int limit = 4}) async {
    return await guard('Get recent diary entries for AI', () async {
      return await supabase
          .from('diary_page')
          .select('date, text, score')
          .eq('user_id', currentUserId)
          .order('date', ascending: false)
          .limit(limit);
    });
  }

  Future<List<JsonObject>> getRecentGratitudeNotes({required String since}) async {
    return await guard('Get recent gratitude notes for AI', () async {
      // recupera le pagine di gratitudine dalla data in poi
      final pages = await supabase
          .from('gratitude_page')
          .select('id, date')
          .eq('user_id', currentUserId)
          .gte('date', since)
          .order('date', ascending: false);

      if (pages.isEmpty) return <JsonObject>[];

      final result = <JsonObject>[];
      for (final page in pages) {
        final notes = await supabase
            .from('gratitude_note')
            .select('text')
            .eq('page_id', page['id'] as String);
        for (final note in notes) {
          result.add({'date': page['date'], 'text': note['text']});
        }
      }
      return result;
    });
  }
}
