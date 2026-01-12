import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/diary_repository.dart';

part 'mood_tracker_event.dart';
part 'mood_tracker_state.dart';

class MoodTrackerBloc extends Bloc<MoodTrackerEvent, MoodTrackerState> {
  final DiaryRepository diaryRepository;

  MoodTrackerBloc({required this.diaryRepository}) : super(InitMoodTrackerState()) {
    on<GetMoodEvent>(_getMood);
  }

  void getMood() => add(GetMoodEvent());

  FutureOr<void> _getMood(
    GetMoodEvent event,
    Emitter<MoodTrackerState> emitter,
  ) async {
    emitter(TryMoodTrackerState());
    try {
      final data = await diaryRepository.getMood();
      emitter(ResultMoodTrackerState(map: data!));
    } catch (e) {
      emitter(ErrorMoodTrackerState(e.toString()));
    }
  }
}
