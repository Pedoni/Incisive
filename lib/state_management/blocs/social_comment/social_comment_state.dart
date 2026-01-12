part of 'social_comment_bloc.dart';

sealed class SocialCommentState extends Equatable {
  const SocialCommentState();

  @override
  List<Object?> get props => [];
}

final class InitSocialCommentState extends SocialCommentState {}

final class LoadingSocialCommentState extends SocialCommentState {}

final class EmptySocialCommentState extends SocialCommentState {}

final class ErrorSocialCommentState extends SocialCommentState {
  final String message;

  const ErrorSocialCommentState(this.message);

  @override
  List<Object?> get props => [message];
}

final class ResultSocialCommentState extends SocialCommentState {
  final List<SocialCommentModel> comments;

  const ResultSocialCommentState(this.comments);

  @override
  List<Object?> get props => [comments];
}
