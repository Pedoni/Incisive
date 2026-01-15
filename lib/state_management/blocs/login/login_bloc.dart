import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/login_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'login_event.dart';

class LoginBloc extends Bloc<BaseEvent, BaseState> {
  final LoginRepository loginRepository;

  LoginBloc({required this.loginRepository}) : super(Initial()) {
    on<TryLoginEvent>(_login);
  }

  void login(String username, String password) => add(TryLoginEvent(username: username, password: password));

  FutureOr<void> _login(
    TryLoginEvent event,
    Emitter<BaseState> emitter,
  ) async {
    emitter(Loading());
    try {
      await loginRepository.login(event.username, event.password);
      emitter(Success(null));
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }

  Future<void> logout() async => await loginRepository.logout();
}
