import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:incisive/models/user_preferences_model.dart';
import 'package:incisive/navigation/app_routes.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/questionnaire/questionnaire_bloc.dart';
import 'package:incisive/utils/incisive_colors.dart';

class PreferencesSection extends StatelessWidget {
  const PreferencesSection({super.key});

  UserPreferences? _extractPrefs(BaseState state) {
    if (state is Success) {
      final data = state.data;
      if (data is UserPreferences) return data;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionnaireBloc, BaseState>(
      builder: (context, state) {

        // debugPrint('PreferencesSection stato: ${state.runtimeType}');

        if (state is Loading || state is Initial) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: CircularProgressIndicator(color: IncisiveColors.primary),
            ),
          );
        }

        final prefs = _extractPrefs(state);

        if (prefs == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              onTap: () => context.push(AppRoutes.questionnaire),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 248, 234, 200),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Text('🐾', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Completa il questionario per personalizzare Pixel',
                        style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 14,
                          color: Color(0xFF4A3728),
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Color(0xFF8D5A23)),
                  ],
                ),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Il tuo Pixel',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8D5A23),
                ),
              ),
              const SizedBox(height: 12),
              _PrefCard(
                category: 'Stile dell\'assistente',
                currentLabel: _labelFor(0, prefs.assistantStyle),
                currentEmoji: _emojiFor(0, prefs.assistantStyle),
                onTap: () => _openSheet(context, 0, prefs),
              ),
              const SizedBox(height: 8),
              _PrefCard(
                category: 'Obiettivo principale',
                currentLabel: _labelFor(1, prefs.mainGoal),
                currentEmoji: _emojiFor(1, prefs.mainGoal),
                onTap: () => _openSheet(context, 1, prefs),
              ),
              const SizedBox(height: 8),
              _PrefCard(
                category: 'Stile di conversazione',
                currentLabel: _labelFor(2, prefs.conversationStyle),
                currentEmoji: _emojiFor(2, prefs.conversationStyle),
                onTap: () => _openSheet(context, 2, prefs),
              ),
              const SizedBox(height: 8),
              _PrefCard(
                category: 'Reazione agli errori',
                currentLabel: _labelFor(3, prefs.errorReaction),
                currentEmoji: _emojiFor(3, prefs.errorReaction),
                onTap: () => _openSheet(context, 3, prefs),
              ),
            ],
          ),
        );
      },
    );
  }

  String _fieldValue(int questionIndex, UserPreferences prefs) {
    return switch (questionIndex) {
      0 => prefs.assistantStyle,
      1 => prefs.mainGoal,
      2 => prefs.conversationStyle,
      3 => prefs.errorReaction,
      _ => '',
    };
  }

  String _labelFor(int questionIndex, String value) {
    final opts = QuestionnaireData.questions[questionIndex].options;
    return opts.firstWhere((o) => o.value == value, orElse: () => opts.first).label;
  }

  String _emojiFor(int questionIndex, String value) {
    final opts = QuestionnaireData.questions[questionIndex].options;
    return opts.firstWhere((o) => o.value == value, orElse: () => opts.first).emoji;
  }

  void _openSheet(BuildContext context, int questionIndex, UserPreferences prefs) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<QuestionnaireBloc>(),
        child: _PreferencesSheet(
          questionIndex: questionIndex,
          currentValue: _fieldValue(questionIndex, prefs),
          currentPrefs: prefs,
        ),
      ),
    );
  }
}

class _PrefCard extends StatelessWidget {
  final String category;
  final String currentLabel;
  final String currentEmoji;
  final VoidCallback onTap;

  const _PrefCard({
    required this.category,
    required this.currentLabel,
    required this.currentEmoji,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 248, 234, 200),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(currentEmoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8D5A23),
                      fontFamily: 'Nunito Sans',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currentLabel,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito Sans',
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF8D5A23)),
          ],
        ),
      ),
    );
  }
}

class _PreferencesSheet extends StatefulWidget {
  final int questionIndex;
  final String currentValue;
  final UserPreferences currentPrefs;

  const _PreferencesSheet({
    required this.questionIndex,
    required this.currentValue,
    required this.currentPrefs,
  });

  @override
  State<_PreferencesSheet> createState() => _PreferencesSheetState();
}

class _PreferencesSheetState extends State<_PreferencesSheet> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.currentValue;
  }

  @override
  Widget build(BuildContext context) {
    final question = QuestionnaireData.questions[widget.questionIndex];

    return BlocListener<QuestionnaireBloc, BaseState>(
      listener: (context, state) {
        // Success<void> --> salvataggio completato
        if (state is Success && state.data == null) {
          Navigator.of(context).pop();
          context.read<QuestionnaireBloc>().add(LoadPreferences());
        }
        if (state is Error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorString ?? 'Errore nel salvataggio.'),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.of(context).viewInsets.bottom + 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              question.question,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A3728),
              ),
            ),
            const SizedBox(height: 16),
            ...question.options.map(
              (opt) => _OptionTile(
                option: opt,
                isSelected: _selectedValue == opt.value,
                onTap: () => setState(() => _selectedValue = opt.value),
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<QuestionnaireBloc, BaseState>(
              builder: (context, state) {
                final isLoading = state is Loading;
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading || _selectedValue == widget.currentValue
                        ? null
                        : () => _save(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: IncisiveColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Salva',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _save(BuildContext context) {
    final prefs = widget.currentPrefs;
    final fieldKey = switch (widget.questionIndex) {
      0 => 'assistant_style',
      1 => 'main_goal',
      2 => 'conversation_style',
      3 => 'error_reaction',
      _ => '',
    };

    context.read<QuestionnaireBloc>().add(
          UpdatePreferences({
            'assistant_style': prefs.assistantStyle,
            'main_goal': prefs.mainGoal,
            'conversation_style': prefs.conversationStyle,
            'error_reaction': prefs.errorReaction,
            fieldKey: _selectedValue,
          }),
        );
  }
}

class _OptionTile extends StatelessWidget {
  final QuestionnaireOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF8D5A23).withValues(alpha: 0.08)
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? const Color(0xFF8D5A23) : Colors.grey.shade300,
            width: isSelected ? 1.5 : 0.5,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Text(option.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option.label,
                style: TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                  color: const Color(0xFF4A3728),
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF8D5A23), size: 20),
          ],
        ),
      ),
    );
  }
}
