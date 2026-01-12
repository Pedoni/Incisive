part of 'comment_post_bloc.dart';

sealed class CommentPostEvent extends Equatable {
  const CommentPostEvent();

  @override
  List<Object> get props => [];
}

class TryCommentPostEvent extends CommentPostEvent {
  final String postId;
  final String content;

  const TryCommentPostEvent({
    required this.content,
    required this.postId,
  });

  @override
  List<Object> get props => [content, postId];
}
