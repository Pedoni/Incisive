part of 'register_bloc.dart';

abstract class RegisterEvent {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class TryRegisterEvent extends RegisterEvent {
  final String username;
  final String password;

  const TryRegisterEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}
