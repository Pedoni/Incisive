class UserPreferences {
  final String id;
  final String userId;
  final String assistantStyle;
  final String mainGoal;
  final String conversationStyle;
  final String errorReaction;

  const UserPreferences({
    required this.id,
    required this.userId,
    required this.assistantStyle,
    required this.mainGoal,
    required this.conversationStyle,
    required this.errorReaction,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      assistantStyle: json['assistant_style'] as String,
      mainGoal: json['main_goal'] as String,
      conversationStyle: json['conversation_style'] as String,
      errorReaction: json['error_reaction'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'assistant_style': assistantStyle,
        'main_goal': mainGoal,
        'conversation_style': conversationStyle,
        'error_reaction': errorReaction,
      };

  UserPreferences copyWith({
    String? assistantStyle,
    String? mainGoal,
    String? conversationStyle,
    String? errorReaction,
  }) {
    return UserPreferences(
      id: id,
      userId: userId,
      assistantStyle: assistantStyle ?? this.assistantStyle,
      mainGoal: mainGoal ?? this.mainGoal,
      conversationStyle: conversationStyle ?? this.conversationStyle,
      errorReaction: errorReaction ?? this.errorReaction,
    );
  }
}

class QuestionnaireOption {
  final String value;   // chiave salvata su supabase
  final String label;   // testo mostrato all'utente
  final String emoji;

  const QuestionnaireOption({
    required this.value,
    required this.label,
    required this.emoji,
  });
}

class QuestionnaireQuestion {
  final int index;         
  final String question;
  final List<QuestionnaireOption> options;

  const QuestionnaireQuestion({
    required this.index,
    required this.question,
    required this.options,
  });
}

class QuestionnaireData {
  static const List<QuestionnaireQuestion> questions = [
    QuestionnaireQuestion(
      index: 0,
      question:
          'Ciao, sono Pixel, il tuo assistente virtuale. \nSono qui per guidarti e aiutarti, che tipo di supporto preferisci ricevere?',
      options: [
        QuestionnaireOption(
          value: 'calm_empathetic',
          label: 'Calmo ed empatico, che mi trasmetta pace',
          emoji: '🌿',
        ),
        QuestionnaireOption(
          value: 'motivator',
          label: 'Motivatore, diretto e che mi dia la carica!',
          emoji: '⚡',
        ),
        QuestionnaireOption(
          value: 'joyful',
          label: 'Gioioso e divertente, per alleggerire la giornata',
          emoji: '😄',
        ),
        QuestionnaireOption(
          value: 'protective',
          label: 'Dolce e protettivo, che mi ascolti senza giudicare',
          emoji: '🤗',
        ),
      ],
    ),
    QuestionnaireQuestion(
      index: 1,
      question:
          'Qual è il motivo principale per cui hai deciso di scaricare questa app?',
      options: [
        QuestionnaireOption(
          value: 'vent',
          label: 'Uno spazio sicuro per sfogarmi quando sono stressato',
          emoji: '💬',
        ),
        QuestionnaireOption(
          value: 'track_mood',
          label: 'Tenere traccia del mio umore e capire le mie emozioni',
          emoji: '📊',
        ),
        QuestionnaireOption(
          value: 'resilience',
          label: 'Non demoralizzarmi e superare i momenti difficili',
          emoji: '💪',
        ),
        QuestionnaireOption(
          value: 'gratitude',
          label: 'Imparare a essere grato e vedere le cose positive',
          emoji: '🌟',
        ),
      ],
    ),
    QuestionnaireQuestion(
      index: 2,
      question:
          'Quando hai un pensiero pesante, come preferisci affrontare la conversazione?',
      options: [
        QuestionnaireOption(
          value: 'open_book',
          label: 'Racconto tutto nei minimi dettagli fin da subito',
          emoji: '📖',
        ),
        QuestionnaireOption(
          value: 'needs_questions',
          label: 'Ho bisogno che qualcuno mi faccia le domande giuste',
          emoji: '🔍',
        ),
        QuestionnaireOption(
          value: 'metaphors',
          label: 'Preferisco frasi brevi, esempi o metafore',
          emoji: '🎭',
        ),
        QuestionnaireOption(
          value: 'introvert',
          label: 'Elaboro prima da solo, poi ne parlo',
          emoji: '🪴',
        ),
      ],
    ),
    QuestionnaireQuestion(
      index: 3,
      question:
          'Quando fai un errore o qualcosa non va come vorresti, come reagisci di solito?',
      options: [
        QuestionnaireOption(
          value: 'self_critic',
          label: 'Mi critico molto e fatico a perdonarmelo',
          emoji: '😔',
        ),
        QuestionnaireOption(
          value: 'problem_solver',
          label: 'Mi arrabbio, ma cerco subito una soluzione pratica',
          emoji: '🔧',
        ),
        QuestionnaireOption(
          value: 'lighten_up',
          label: 'Cerco di sdrammatizzare o riderci su',
          emoji: '😅',
        ),
        QuestionnaireOption(
          value: 'frozen',
          label: 'Mi sento bloccato dalla delusione e ho bisogno di tempo',
          emoji: '🫂',
        ),
      ],
    ),
  ];
}
