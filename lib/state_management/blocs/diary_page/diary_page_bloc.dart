import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/diary_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'diary_page_event.dart';

class DiaryPageBloc extends BaseBloc {
  final DiaryRepository diaryRepository;

  DiaryPageBloc({required this.diaryRepository}) : super(Initial()) {
    on<TryDiaryPageEvent>(_getPage);
  }

  void getPage(DateTime dateTime) => add(TryDiaryPageEvent(dateTime: dateTime));

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
}
