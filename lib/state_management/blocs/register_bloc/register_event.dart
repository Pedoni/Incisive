part of 'register_bloc.dart';

abstract class RegisterEvent {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class TryRegisterEvent extends RegisterEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const TryRegisterEvent({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object> get props => [email, password];
}
