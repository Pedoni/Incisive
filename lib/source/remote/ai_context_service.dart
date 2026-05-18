import 'package:incisive/models/ai_preferences_model.dart';
import 'package:incisive/source/remote/ai_service.dart';

/// assembla il system prompt dinamico
class AiContextService {
  final AiService aiService;

  static const int _gratitudeDays = 7;
  static const int _recentDiaryDays = 7;

  AiContextService({required this.aiService});

  Future<String> buildSystemPrompt() async {
    final sinceStr = _toSqlDate(
      DateTime.now().subtract(const Duration(days: _gratitudeDays)),
    );

    final results = await Future.wait([
      _fetchPreferences(),
      _fetchDiary(),
      _fetchGratitude(sinceStr),
    ]);

    return _assemblePrompt(
      preferencesSection: results[0],
      diarySection: results[1],
      gratitudeSection: results[2],
    );
  }

  Future<String> _fetchPreferences() async {
    try {
      final prefs = await aiService.getPreferences();
      return prefs.toPromptSection();
    } catch (_) {
      return const AiPreferencesModel.defaults().toPromptSection();
    }
  }

  Future<String> _fetchDiary() async {
    try {
      // riassunti mensili storici
      final summaries = await aiService.getMonthlySummaries();

      // ultime voci recenti (ultimi 7 giorni)
      final since = _toSqlDate(
        DateTime.now().subtract(const Duration(days: _recentDiaryDays)),
      );
      final recentEntries = await aiService.getRecentDiaryEntriesSince(since: since);

      if (summaries.isEmpty && recentEntries.isEmpty) return '';

      final buffer = StringBuffer();

      if (summaries.isNotEmpty) {
        buffer.writeln('RIASSUNTI MENSILI DEL DIARIO:');
        for (final row in summaries) {
          final monthName = _monthName(row['month'] as int);
          final year = row['year'] as int;
          buffer.writeln('• [$monthName $year] ${row['summary']}');
        }
        buffer.writeln();
      }

      if (recentEntries.isNotEmpty) {
        buffer.writeln('VOCI RECENTI DEL DIARIO (ultimi 7 giorni):');
        for (final row in recentEntries) {
          final date = _formatDate(DateTime.parse(row['date'] as String));
          buffer.writeln('• [$date] ${row['text']}');
        }
      }

      return buffer.toString();
    } catch (_) {
      return '';
    }
  }

  String _monthName(int month) {
    const names = [
      '', 'Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno',
      'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'
    ];
    return names[month];
  }

  Future<String> _fetchGratitude(String since) async {
    try {
      final rows = await aiService.getRecentGratitudeNotes(since: since);
      if (rows.isEmpty) return '';

      final buffer = StringBuffer();
      buffer.writeln("COSE PER CUI L'UTENTE È STATO GRATO DI RECENTE:");
      for (final row in rows) {
        final date = _formatDate(DateTime.parse(row['date'] as String));
        final text = row['text'] as String? ?? '';
        buffer.writeln('• [$date] $text');
      }
      return buffer.toString();
    } catch (_) {
      return '';
    }
  }

  String _assemblePrompt({
    required String preferencesSection,
    required String diarySection,
    required String gratitudeSection,
  }) {
    final hasContext = diarySection.isNotEmpty || gratitudeSection.isNotEmpty;

    final contextBlock = hasContext ? '''

--- CONTESTO PERSONALE DELL'UTENTE ---
Queste informazioni ti aiutano a capire come sta l'utente e cosa è successo
di recente nella sua vita. Usale con naturalezza: non citarle mai direttamente,
non dire "ho letto nel tuo diario" o "vedo che sei stato grato di...".
Integra questa conoscenza nel tuo tono e nelle tue domande, come farebbe
un amico che ricorda le cose importanti senza doverle rileggere.
Se l'utente sembra triste, puoi usare i momenti positivi per tirarlo su.

$diarySection
$gratitudeSection--- FINE CONTESTO ---
''' : '';

    return '''
Sei un gatto assistente per il benessere mentale. Il tuo nome è Pixel.
Accompagni l'utente nella riflessione sulla sua giornata, sulle emozioni
e sulle piccole cose positive. Non giudichi, non fai diagnosi e non fornisci
consigli medici o clinici.

Potrebbe non essere la prima volta che l'utente interagisce con te, quindi
non dare per scontato il suo stato emotivo o il suo livello di familiarità
con l'app.

Conosci il funzionamento dell'app INCISIVE, in particolare:
- nella **camera da letto** l'utente può premere sull'icona del diario per scrivere
  le note di diario, oppure può premere sulla cuccia di Pixel per accedere alla chat con te;
- nel **salotto** l'utente può premere sulla lavagna per accedere al daily gratitude;
- nel **giardino** l'utente può premere sulla statua di Buddha per avviare
  un esercizio di respirazione guidata;
- nella **piazza** l'utente può premere sulla bacheca per accedere all'angolo social,
  dove sono presenti post e commenti degli altri utenti, in forma sempre anonima.

Valida sempre le emozioni, tuttavia, mantieni sempre una salda bussola morale: 
se l'utente è nel torto (es. è arrabbiato perché è stato punito per un suo cattivo comportamento), 
valida l'emozione ma non l'azione, guida l'utente a sviluppare empatia verso gli altri.

Suggerisci le diverse aree dell'app solo quando sono coerenti con 
lo stato dell'utente (es. gratitudine in momenti di negatività, respirazione in momenti di agitazione).

Alcune attività permettono di guadagnare punti esperienza, che consentono
all'utente di avanzare di livello. Puoi menzionare questo meccanismo in modo
leggero e motivante, senza renderlo competitivo.

$preferencesSection$contextBlock''';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = DateTime(now.year, now.month, now.day)
        .difference(DateTime(date.year, date.month, date.day))
        .inDays;
    if (diff == 0) return 'oggi';
    if (diff == 1) return 'ieri';
    if (diff < 7) return '$diff giorni fa';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _toSqlDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
