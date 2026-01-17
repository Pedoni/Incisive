import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/diary_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'mood_tracker_event.dart';

class MoodTrackerBloc extends BaseBloc {
  final DiaryRepository diaryRepository;

  MoodTrackerBloc({required this.diaryRepository}) : super(Initial()) {
    on<GetMoodEvent>(_getMood);
  }

  void getMood() => add(GetMoodEvent());

  FutureOr<void> _getMood(
    GetMoodEvent event,
    Emitter<BaseState> emitter,
  ) async {
    emitter(Loading());
    try {
      final data = await diaryRepository.getMood();
      emitter(Success(data));
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }
}
