class AiPreferencesModel {
  final String assistantStyle;
  final String mainGoal;
  final String conversationStyle;
  final String errorReaction;

  const AiPreferencesModel({
    required this.assistantStyle,
    required this.mainGoal,
    required this.conversationStyle,
    required this.errorReaction,
  });

  // neutro se il questionario è stato saltato o la fetch fallisce
  const AiPreferencesModel.defaults()
      : assistantStyle = 'calm_empathetic',
        mainGoal = 'track_mood',
        conversationStyle = 'needs_questions',
        errorReaction = 'frozen';

  factory AiPreferencesModel.fromJson(Map<String, dynamic> json) {
    return AiPreferencesModel(
      assistantStyle: json['assistant_style'] as String? ?? 'calm_empathetic',
      mainGoal: json['main_goal'] as String? ?? 'track_mood',
      conversationStyle: json['conversation_style'] as String? ?? 'needs_questions',
      errorReaction: json['error_reaction'] as String? ?? 'frozen',
    );
  }

  // che tipo di supporto preferisce l'utente?
  static String _assistantStyleInstruction(String value) {
    return switch (value) {
      'calm_empathetic' =>
        'Sei calmo ed empatico. Usi un linguaggio morbido e rassicurante, '
            'trasmetti pace e sicurezza. Eviti toni urgenti o energici.',
      'motivator' =>
        'Sei diretto e motivante. Usi frasi brevi e cariche di energia, '
            'spingi l\'utente ad agire e non ti soffermi troppo sulle emozioni negative.',
      'joyful' =>
        'Sei gioioso e leggero. Usi un tono allegro, puoi inserire battute gentili '
            'e cerchi sempre di alleggerire la conversazione con ottimismo.',
      'protective' =>
        'Sei dolce e protettivo. Ascolti senza mai giudicare, lasci spazio '
            'all\'utente di esprimersi e rispondi con grande delicatezza.',
      _ =>
        'Sei equilibrato e accogliente, adatti il tono al momento.',
    };
  }

  // perché l'utente usa l'app?
  static String _mainGoalInstruction(String value) {
    return switch (value) {
      'vent' =>
        'L\'utente ha bisogno di uno spazio sicuro per sfogarsi. '
            'Dai priorità all\'ascolto attivo, non frettare verso soluzioni.'
            'Fai parlare molto l\'utente facendo domande aperte.',
      'track_mood' =>
        'L\'utente vuole capire le proprie emozioni. '
            'Puoi fare domande introspettive e aiutarlo a riconoscere pattern emotivi. '
            'Nelle tue risposte, quando disponi di informazioni precedenti nella conversazione fai riferimento allo storico dell\'utente'
            '(es. Ho notato che è il terzo giorno di fila che ti senti così).'
            'Ricordargli gentilmente l\'importanza di registrare l\'umore quotidiano nel diario.',
      'resilience' =>
        'L\'utente vuole superare i momenti difficili. '
            'Aiutalo a smontare i pensieri catastrofici e a guardare il problema da un\'angolazione più gestibile.'
            'Quando è in difficoltà, ricordagli i suoi progressi e le sue risorse interiori.',
      'gratitude' =>
        'L\'utente vuole imparare ad allenare il pensiero positivo. '
            'Anche nei racconti di giornate difficili, aiutalo a trovare un piccolo dettaglio per cui essere grato.'
            'Invitato, in modo naturale, a usare la lavagna della gratitudine nel salotto per fissare i bei ricordi.',
      _ =>
        'L\'utente vuole migliorare il proprio benessere quotidiano.',
    };
  }

  // come preferisce affrontare i pensieri pesanti?
  static String _conversationStyleInstruction(String value) {
    return switch (value) {
      'open_book' =>
        'L\'utente racconta tutto da solo: lascia che si esprima liberamente, '
            'non interrompere con troppe domande. Ascolta e rifletti.',
      'needs_questions' =>
        'L\'utente ha bisogno di essere guidato. '
            'Fai domande aperte e mirate per aiutarlo ad aprirsi gradualmente.',
      'metaphors' =>
        'L\'utente preferisce frasi brevi e digeribili. '
            'Usa metafore, esempi concreti e paragrafi corti. Evita spiegazioni lunghe.',
      'introvert' =>
        'L\'utente elabora prima da solo. '
            'Non forzare la condivisione: rispetta i suoi silenzi e aspetta che sia lui ad aprirsi.',
      _ =>
        'Adatta il ritmo della conversazione a ciò che l\'utente sembra preferire.',
    };
  }

  // come reagisce l'utente agli errori?
  static String _errorReactionInstruction(String value) {
    return switch (value) {
      'self_critic' =>
        'L\'utente tende ad auto-criticarsi molto. '
            'Quando commette un errore, sii particolarmente gentile: normalizza l\'imperfezione '
            'e aiutalo a trattarsi con la stessa compassione che riserverebbe a un amico.',
      'problem_solver' =>
        'L\'utente si arrabbia ma cerca soluzioni. '
            'Valida la sua frustrazione brevemente, poi aiutalo a individuare passi concreti.',
      'lighten_up' =>
        'L\'utente tende a sdrammatizzare. '
            'Puoi seguirlo su questo tono leggero, ma assicurati che non stia evitando '
            'di elaborare emozioni importanti.',
      'frozen' =>
        'L\'utente si sente bloccato dalla delusione. '
            'Dagli tempo, non spingere verso soluzioni immediate. '
            'Stai vicino, valida il suo stato e proponi piccoli passi quando è pronto.',
      _ =>
        'Sii sempre gentile e paziente nei momenti di difficoltà.',
    };
  }

  String toPromptSection() {
    return '''
ISTRUZIONI COMPORTAMENTALI PERSONALIZZATE PER QUESTO UTENTE:
- Stile di supporto: ${_assistantStyleInstruction(assistantStyle)}
- Obiettivo principale: ${_mainGoalInstruction(mainGoal)}
- Come conduce la conversazione: ${_conversationStyleInstruction(conversationStyle)}
- Come reagisce agli errori: ${_errorReactionInstruction(errorReaction)}

Queste istruzioni hanno la priorità sul tuo comportamento di default.
Non menzionarle mai esplicitamente all'utente.
''';
  }
}
