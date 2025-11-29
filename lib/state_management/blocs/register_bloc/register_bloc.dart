import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/login_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final LoginRepository loginRepository;

  RegisterBloc({required this.loginRepository}) : super(const InitRegisterState()) {
    on<TryRegisterEvent>(_register);
  }

  void register(String username, String password) => add(TryRegisterEvent(username: username, password: password));

  FutureOr<void> _register(
    RegisterEvent event,
    Emitter<RegisterState> emitter,
  ) async {
    emitter(const TryRegisterState());
    try {
      var e = event as TryRegisterEvent;
      await loginRepository.register(e.username, e.password);
      emitter(const ResultRegisterState());
    } catch (e) {
      emitter(ErrorRegisterState(e.toString()));
    }
  }
}
