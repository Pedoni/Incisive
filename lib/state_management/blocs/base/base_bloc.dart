import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'base_event.dart';
part 'base_state.dart';

abstract class BaseBloc extends Bloc<BaseEvent, BaseState> {
  BaseBloc(super.initialState);

  Future<void> runWithLoading<T>({
    required Emitter<BaseState> emit,
    required Future<T> Function() action,
  }) async {
    emit(Loading());
    try {
      final result = await action();
      emit(Success<T>(result));
    } catch (e, st) {
      addError(e, st);
      emit(Error(e.toString()));
    }
  }
}

extension SuccessX on BaseState {
  T? data<T>() => this is Success<T> ? (this as Success<T>).data : null;
}
