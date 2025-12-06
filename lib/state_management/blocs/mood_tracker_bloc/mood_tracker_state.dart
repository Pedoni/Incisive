part of 'mood_tracker_bloc.dart';

sealed class MoodTrackerState extends Equatable {
  const MoodTrackerState();

  @override
  List<Object> get props => [];
}

final class InitMoodTrackerState extends MoodTrackerState {}

final class TryMoodTrackerState extends MoodTrackerState {}

final class ResultMoodTrackerState extends MoodTrackerState {
  final Map<DateTime, double> map;

  const ResultMoodTrackerState({required this.map});
}

final class EmptyMoodTrackerState extends MoodTrackerState {}

final class ErrorMoodTrackerState extends MoodTrackerState {
  final String? errorString;
  const ErrorMoodTrackerState(this.errorString);
}
