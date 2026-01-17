import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/diary_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'upsert_page_event.dart';

class UpsertPageBloc extends BaseBloc {
  final DiaryRepository diaryRepository;

  UpsertPageBloc({required this.diaryRepository}) : super(Initial()) {
    on<TryUpsertPageEvent>(_upsertPage);
  }

  void upsertPage(
    DateTime dateTime,
    String text,
  ) => add(
    TryUpsertPageEvent(
      dateTime: dateTime,
      text: text,
    ),
  );

  FutureOr<void> _upsertPage(
    TryUpsertPageEvent event,
    Emitter<BaseState> emitter,
  ) async {
    emitter(Loading());
    try {
      await diaryRepository.upsertPage(date: event.dateTime, text: event.text);
      emitter(Success<void>(null));
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }
}
