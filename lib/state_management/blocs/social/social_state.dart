part of 'social_bloc.dart';

sealed class SocialState extends Equatable {
  const SocialState();

  @override
  List<Object?> get props => [];
}

final class InitSocialState extends SocialState {}

final class LoadingSocialState extends SocialState {}

final class EmptySocialState extends SocialState {}

final class ErrorSocialState extends SocialState {
  final String message;

  const ErrorSocialState(this.message);

  @override
  List<Object?> get props => [message];
}

final class ResultSocialState extends SocialState {
  final List<SocialPostModel> posts;

  const ResultSocialState(this.posts);

  @override
  List<Object?> get props => [posts];
}
