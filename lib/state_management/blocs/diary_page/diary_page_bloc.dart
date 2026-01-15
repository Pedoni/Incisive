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
    await runWithLoading(
      emit: emitter,
      action: () async => await diaryRepository.getPage(event.dateTime),
    );
  }
}
