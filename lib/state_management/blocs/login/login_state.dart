part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class InitLoginState extends LoginState {}

final class TryLoginState extends LoginState {}

final class ResultLoginState extends LoginState {}

final class EmptyLoginState extends LoginState {}

final class ErrorLoginState extends LoginState {
  final String? errorString;
  const ErrorLoginState(this.errorString);
}
