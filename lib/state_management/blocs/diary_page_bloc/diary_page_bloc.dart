import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/diary_model.dart';
import 'package:incisive/repositories/diary_repository.dart';

part 'diary_page_event.dart';
part 'diary_page_state.dart';

class DiaryPageBloc extends Bloc<DiaryPageEvent, DiaryPageState> {
  final DiaryRepository diaryRepository;

  DiaryPageBloc({required this.diaryRepository}) : super(const InitDiaryPageState()) {
    on<TryDiaryPageEvent>(_getPage);
  }

  void getPage(DateTime dateTime) => add(TryDiaryPageEvent(dateTime: dateTime));

  FutureOr<void> _getPage(
    TryDiaryPageEvent event,
    Emitter<DiaryPageState> emitter,
  ) async {
    emitter(const TryDiaryPageState());
    try {
      final entry = await diaryRepository.getPage(event.dateTime);
      emitter(entry != null ? ResultDiaryPageState(entry: entry) : EmptyDiaryPageState());
    } catch (e) {
      emitter(ErrorDiaryPageState(e.toString()));
    }
  }
}
