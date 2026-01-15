part of 'base_bloc.dart';

sealed class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];
}

final class Initial extends BaseState {}

final class Loading extends BaseState {}

final class Empty<T> extends BaseState {
  final T? data;
  const Empty({this.data});

  @override
  List<Object?> get props => [data];
}

final class Success<T> extends BaseState {
  final T data;
  const Success(this.data);

  @override
  List<Object?> get props => [data];
}

final class Error extends BaseState {
  final String? errorString;
  const Error(this.errorString);

  @override
  List<Object?> get props => [errorString];
}
