part of 'login_bloc.dart';

class TryLoginEvent extends BaseEvent {
  final String username;
  final String password;

  const TryLoginEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}
