part of 'comment_post_bloc.dart';

sealed class CommentPostState extends Equatable {
  const CommentPostState();

  @override
  List<Object> get props => [];
}

class InitCommentPostState extends CommentPostState {
  const InitCommentPostState();
}

class TryCommentPostState extends CommentPostState {
  const TryCommentPostState();
}

class ResultCommentPostState extends CommentPostState {
  const ResultCommentPostState();
}

class EmptyCommentPostState extends CommentPostState {
  const EmptyCommentPostState();
}

class ErrorCommentPostState extends CommentPostState {
  final String? errorString;
  const ErrorCommentPostState(this.errorString);
}
