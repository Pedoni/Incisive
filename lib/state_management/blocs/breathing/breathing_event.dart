part of 'breathing_bloc.dart';

sealed class BreathingEvent extends Equatable {
  const BreathingEvent();

  @override
  List<Object> get props => [];
}

class TryCompleteBreathingEvent extends BreathingEvent {
  const TryCompleteBreathingEvent();

  @override
  List<Object> get props => [];
}
