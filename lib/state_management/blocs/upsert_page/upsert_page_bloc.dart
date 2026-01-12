import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/diary_repository.dart';

part 'upsert_page_event.dart';
part 'upsert_page_state.dart';

class UpsertPageBloc extends Bloc<UpsertPageEvent, UpsertPageState> {
  final DiaryRepository diaryRepository;

  UpsertPageBloc({required this.diaryRepository}) : super(const InitUpsertPageState()) {
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
    Emitter<UpsertPageState> emitter,
  ) async {
    emitter(const TryUpsertPageState());
    try {
      await diaryRepository.upsertPage(date: event.dateTime, text: event.text);
      emitter(const ResultUpsertPageState());
    } catch (e) {
      emitter(ErrorUpsertPageState(e.toString()));
    }
  }
}
