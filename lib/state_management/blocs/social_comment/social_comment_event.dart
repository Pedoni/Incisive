part of 'social_comment_bloc.dart';

sealed class SocialCommentEvent extends Equatable {
  const SocialCommentEvent();

  @override
  List<Object?> get props => [];
}

class GetCommentsForPostEvent extends SocialCommentEvent {
  final String postId;

  const GetCommentsForPostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class CreateCommentEvent extends SocialCommentEvent {
  final String postId;
  final String content;

  const CreateCommentEvent(this.postId, this.content);

  @override
  List<Object?> get props => [postId, content];
}

class ApproveCommentEvent extends SocialCommentEvent {
  final String commentId;
  final String postId;

  const ApproveCommentEvent(this.commentId, this.postId);

  @override
  List<Object?> get props => [commentId, postId];
}

class VoteCommentEvent extends SocialCommentEvent {
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

class RejectCommentEvent extends SocialCommentEvent {
  final String commentId;
  final String postId;

  const RejectCommentEvent(this.commentId, this.postId);

  @override
  List<Object?> get props => [commentId, postId];
}
