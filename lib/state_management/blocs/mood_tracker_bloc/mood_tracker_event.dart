part of 'mood_tracker_bloc.dart';

sealed class MoodTrackerEvent extends Equatable {
  const MoodTrackerEvent();

  @override
  List<Object> get props => [];
}

class GetMoodEvent extends MoodTrackerEvent {
  const GetMoodEvent();

  @override
  List<Object> get props => [];
}
