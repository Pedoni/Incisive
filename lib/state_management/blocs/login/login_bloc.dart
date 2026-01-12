import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc({required this.loginRepository}) : super(const InitLoginState()) {
    on<TryLoginEvent>(_login);
  }

  void login(String username, String password) => add(TryLoginEvent(username: username, password: password));

  FutureOr<void> _login(
    LoginEvent event,
    Emitter<LoginState> emitter,
  ) async {
    emitter(const TryLoginState());
    try {
      var e = event as TryLoginEvent;
      await loginRepository.login(e.username, e.password);
      emitter(const ResultLoginState());
    } catch (e) {
      emitter(ErrorLoginState(e.toString()));
    }
  }

  Future<void> logout() async => await loginRepository.logout();
}
