import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/user_preferences_model.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

abstract class QuestionnaireEvent {}

class AnswerSelected extends QuestionnaireEvent {
  final int questionIndex;
  final String value;
  AnswerSelected({required this.questionIndex, required this.value});
}

// per salvare le risposte e proseguire
class SubmitQuestionnaire extends QuestionnaireEvent {}

// carica le preferenze esistenti
class LoadPreferences extends QuestionnaireEvent {}

// salva preferenze aggiornate dalla pagina profilo
class UpdatePreferences extends QuestionnaireEvent {
  final Map<String, String> answers;
  UpdatePreferences(this.answers);
}

class SkipQuestionnaire extends QuestionnaireEvent {}

class QuestionnaireBloc extends Bloc<QuestionnaireEvent, BaseState> {
  QuestionnaireBloc() : super(const Empty<Map<int, String>>(data: {})) {
    on<AnswerSelected>(_onAnswerSelected);
    on<SubmitQuestionnaire>(_onSubmit);
    on<LoadPreferences>(_onLoad);
    on<UpdatePreferences>(_onUpdate);
    on<SkipQuestionnaire>(_onSkip);
  }

  final _supabase = Supabase.instance.client;

  // helpers per leggere le risposte dallo stato corrente
  Map<int, String> get _currentAnswers =>
      state is Empty<Map<int, String>>
          ? (state as Empty<Map<int, String>>).data ?? {}
          : {};

  void _onAnswerSelected(AnswerSelected event, Emitter<BaseState> emit) {
    final updated = Map<int, String>.from(_currentAnswers)
      ..[event.questionIndex] = event.value;
    emit(Empty<Map<int, String>>(data: updated));
  }

  Future<void> _onSubmit(
      SubmitQuestionnaire event, Emitter<BaseState> emit) async {
    final answers = _currentAnswers;

    if (answers.length < 4) return;

    emit(Loading());

    try {
      final userId = _supabase.auth.currentUser!.id;
      
      await _supabase.from('user_preferences').upsert({
        'user_id': userId,
        'assistant_style': answers[0]!,
        'main_goal': answers[1]!,
        'conversation_style': answers[2]!,
        'error_reaction': answers[3]!,
      },
      onConflict: 'user_id',
      );
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('questionnaire_done', true);

      emit(Success<void>(null));
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  Future<void> _onLoad(LoadPreferences event, Emitter<BaseState> emit) async {
    emit(Loading());
    try {
      final userId = _supabase.auth.currentUser!.id;
      final data = await _supabase
          .from('user_preferences')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (data != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('questionnaire_done', true);
        // Success<UserPreferences>: preferenze trovate
        emit(Success<UserPreferences>(UserPreferences.fromJson(data)));
      } else {
        // nessuna preferenza ancora: torna allo stato vuoto
        emit(const Empty<Map<int, String>>(data: {}));
      }
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  Future<void> _onUpdate(
      UpdatePreferences event, Emitter<BaseState> emit) async {
    emit(Loading());
    try {
      final userId = _supabase.auth.currentUser!.id;
      await _supabase.from('user_preferences')
        .update(event.answers)
        .eq('user_id', userId);
      emit(const Success<void>(null));
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  Future<void> _onSkip(
      SkipQuestionnaire event, Emitter<BaseState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('questionnaire_done', true);
      emit(const Success<void>(null));
    } catch (e) {
      emit(Error(e.toString()));
    }
  }
}
