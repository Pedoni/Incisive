import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/login_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'register_event.dart';

class RegisterBloc extends BaseBloc {
  final LoginRepository loginRepository;

  RegisterBloc({required this.loginRepository}) : super(Initial()) {
    on<TryRegisterEvent>(_register);
  }

  void register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) => add(
    TryRegisterEvent(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    ),
  );

  FutureOr<void> _register(
    TryRegisterEvent event,
    Emitter<BaseState> emitter,
  ) async {
    emitter(Loading());
    try {
      await loginRepository.register(
        event.email,
        event.password,
        event.firstName,
        event.lastName,
      );
      emitter(Success(null));
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }
}
