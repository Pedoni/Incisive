part of 'comment_post_bloc.dart';

sealed class CommentPostState extends Equatable {
  const CommentPostState();

  @override
  List<Object> get props => [];
}

final class InitCommentPostState extends CommentPostState {}

final class TryCommentPostState extends CommentPostState {}

final class ResultCommentPostState extends CommentPostState {}

final class EmptyCommentPostState extends CommentPostState {}

final class ErrorCommentPostState extends CommentPostState {
  final String? errorString;
  const ErrorCommentPostState(this.errorString);
}
