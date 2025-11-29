part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class InitLoginState extends LoginState {
  const InitLoginState();
}

class TryLoginState extends LoginState {
  const TryLoginState();
}

class ResultLoginState extends LoginState {
  const ResultLoginState();
}

class EmptyLoginState extends LoginState {
  const EmptyLoginState();
}

class ErrorLoginState extends LoginState {
  final String? errorString;
  const ErrorLoginState(this.errorString);
}
