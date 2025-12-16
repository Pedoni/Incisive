part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class InitialProfileState extends ProfileState {}

final class LoadingProfileState extends ProfileState {}

final class EmptyProfileState extends ProfileState {}

final class ResultProfileState extends ProfileState {}

final class ErrorProfileState extends ProfileState {
  final String? errorString;

  const ErrorProfileState(this.errorString);
}
