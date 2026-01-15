import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/social_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'create_post_event.dart';

class CreatePostBloc extends BaseBloc {
  final SocialRepository socialRepository;

  CreatePostBloc({required this.socialRepository}) : super(Initial()) {
    on<TryCreatePostEvent>(_createPost);
  }

  void createPost(
    String title,
    String content,
  ) => add(
    TryCreatePostEvent(
      title: title,
      content: content,
    ),
  );

  FutureOr<void> _createPost(
    TryCreatePostEvent event,
    Emitter<BaseState> emitter,
  ) async {
    emitter(Loading());
    try {
      await socialRepository.createPost(
        title: event.title,
        content: event.content,
      );
      emitter(Success(null));
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }
}
