import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:incisive/repositories/breathing_repository.dart';

part 'breathing_event.dart';
part 'breathing_state.dart';

class BreathingBloc extends Bloc<BreathingEvent, BreathingState> {
  final BreathingRepository breathingRepository;

  BreathingBloc({required this.breathingRepository}) : super(InitialBreathingState()) {
    on<TryCompleteBreathingEvent>(_completeBreathing);
  }

  void completeBreathing() => add(TryCompleteBreathingEvent());

  Future<void> _completeBreathing(
    TryCompleteBreathingEvent event,
    Emitter<BreathingState> emitter,
  ) async {
    emitter(LoadingBreathingState());
    try {
      final points = await breathingRepository.completeBreathing();
      emitter(ResultBreathingState(points: points));
    } catch (e) {
      emitter(ErrorBreathingState(message: e.toString()));
    }
  }
}
