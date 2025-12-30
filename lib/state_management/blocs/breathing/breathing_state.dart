part of 'breathing_bloc.dart';

sealed class BreathingState extends Equatable {
  const BreathingState();

  @override
  List<Object> get props => [];
}

final class InitialBreathingState extends BreathingState {}

final class LoadingBreathingState extends BreathingState {}

final class ResultBreathingState extends BreathingState {
  final int points;

  const ResultBreathingState({required this.points});

  @override
  List<Object> get props => [points];
}

final class ErrorBreathingState extends BreathingState {
  final String message;

  const ErrorBreathingState({required this.message});

  @override
  List<Object> get props => [message];
}
