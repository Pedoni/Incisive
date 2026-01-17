import 'package:bloc/bloc.dart';
import 'package:incisive/repositories/breathing_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'breathing_event.dart';

class BreathingBloc extends BaseBloc {
  final BreathingRepository breathingRepository;

  BreathingBloc({required this.breathingRepository}) : super(Initial()) {
    on<TryCompleteBreathingEvent>(_completeBreathing);
  }

  void completeBreathing() => add(TryCompleteBreathingEvent());

  Future<void> _completeBreathing(
    TryCompleteBreathingEvent event,
    Emitter<BaseState> emitter,
  ) async {
    emitter(Loading());
    try {
      final points = await breathingRepository.completeBreathing();
      emitter(Success(points));
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }
}
