part of 'comment_post_bloc.dart';

class TryCommentPostEvent extends BaseEvent {
  final String postId;
  final String content;

  const TryCommentPostEvent({
    required this.content,
    required this.postId,
  });

  @override
  List<Object> get props => [content, postId];
}
