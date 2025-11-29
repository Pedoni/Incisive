part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class InitRegisterState extends RegisterState {
  const InitRegisterState();
}

class TryRegisterState extends RegisterState {
  const TryRegisterState();
}

class ResultRegisterState extends RegisterState {
  const ResultRegisterState();
}

class EmptyRegisterState extends RegisterState {
  const EmptyRegisterState();
}

class ErrorRegisterState extends RegisterState {
  final String? errorString;
  const ErrorRegisterState(this.errorString);
}
