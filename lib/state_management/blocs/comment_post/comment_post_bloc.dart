import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:incisive/repositories/social_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'comment_post_event.dart';

class CommentPostBloc extends BaseBloc {
  final SocialRepository socialRepository;

  CommentPostBloc({required this.socialRepository}) : super(Initial()) {
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
    Emitter<BaseState> emitter,
  ) async {
    emitter(Loading());
    try {
      await socialRepository.createComment(
        postId: event.postId,
        content: event.content,
      );
      emitter(Success(null));
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }
}
