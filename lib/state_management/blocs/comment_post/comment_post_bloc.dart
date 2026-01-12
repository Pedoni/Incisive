import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:incisive/repositories/social_repository.dart';

part 'comment_post_event.dart';
part 'comment_post_state.dart';

class CommentPostBloc extends Bloc<CommentPostEvent, CommentPostState> {
  final SocialRepository socialRepository;

  CommentPostBloc({required this.socialRepository}) : super(InitCommentPostState()) {
    on<TryCommentPostEvent>(_commentPost);
  }

  void commentPost(
    String postId,
    String content,
  ) => add(
    TryCommentPostEvent(
      postId: postId,
      content: content,
    ),
  );

  FutureOr<void> _commentPost(
    TryCommentPostEvent event,
    Emitter<CommentPostState> emitter,
  ) async {
    emitter(TryCommentPostState());
    try {
      await socialRepository.createComment(
        postId: event.postId,
        content: event.content,
      );
      emitter(ResultCommentPostState());
    } catch (e) {
      emitter(ErrorCommentPostState(e.toString()));
    }
  }
}
