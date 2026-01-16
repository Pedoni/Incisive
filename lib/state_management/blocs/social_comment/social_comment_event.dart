part of 'social_comment_bloc.dart';

class GetCommentsForPostEvent extends BaseEvent {
  final String postId;

  const GetCommentsForPostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class CreateCommentEvent extends BaseEvent {
  final String postId;
  final String content;

  const CreateCommentEvent(this.postId, this.content);

  @override
  List<Object?> get props => [postId, content];
}

class ApproveCommentEvent extends BaseEvent {
  final String commentId;
  final String postId;

  const ApproveCommentEvent(this.commentId, this.postId);

  @override
  List<Object?> get props => [commentId, postId];
}

class VoteCommentEvent extends BaseEvent {
  final String commentId;
  final String postId;
  final bool isUpvote;

  const VoteCommentEvent(
    this.commentId,
    this.postId,
    this.isUpvote,
  );

  @override
  List<Object?> get props => [commentId, postId, isUpvote];
}

class RejectCommentEvent extends BaseEvent {
  final String commentId;
  final String postId;

  const RejectCommentEvent(this.commentId, this.postId);

  @override
  List<Object?> get props => [commentId, postId];
}
