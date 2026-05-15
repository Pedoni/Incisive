import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/diary_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'diary_page_event.dart';

class DiaryPageBloc extends BaseBloc {
  final DiaryRepository diaryRepository;

  DiaryPageBloc({required this.diaryRepository}) : super(Initial()) {
    on<TryDiaryPageEvent>(_getPage);
    on<UpdateDiaryPrivacyEvent>(_updatePrivacy);
  }

  void getPage(DateTime dateTime) => add(TryDiaryPageEvent(dateTime: dateTime));

  void updatePrivacy(DateTime date, bool isPrivate) =>
      add(UpdateDiaryPrivacyEvent(date: date, isPrivate: isPrivate));

  FutureOr<void> _getPage(
    TryDiaryPageEvent event,
    Emitter<BaseState> emitter,
  ) async {
    emitter(Loading());
    try {
      final entry = await diaryRepository.getPage(event.dateTime);
      emitter(entry != null ? Success(entry) : Empty());
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }

  FutureOr<void> _updatePrivacy(
    UpdateDiaryPrivacyEvent event,
    Emitter<BaseState> emitter,
  ) async {
    // mantiene lo stato corrente durante il salvataggio
    final currentState = state;
    try {
      await diaryRepository.updatePrivacy(
        date: event.date,
        isPrivate: event.isPrivate,
      );
      // aggiorna la voce nello stato con il nuovo valore isPrivate
      if (currentState is Success) {
        final entry = currentState.data as dynamic;
        emitter(Success(entry.copyWith(isPrivate: event.isPrivate)));
      }
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }
}
