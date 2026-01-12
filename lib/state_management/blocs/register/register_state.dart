part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

final class InitRegisterState extends RegisterState {}

final class TryRegisterState extends RegisterState {}

final class ResultRegisterState extends RegisterState {}

final class EmptyRegisterState extends RegisterState {}

final class ErrorRegisterState extends RegisterState {
  final String? errorString;
  const ErrorRegisterState(this.errorString);
}
