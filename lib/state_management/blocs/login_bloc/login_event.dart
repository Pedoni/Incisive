part of 'login_bloc.dart';

abstract class LoginEvent {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class TryLoginEvent extends LoginEvent {
  final String username;
  final String password;

  const TryLoginEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}
