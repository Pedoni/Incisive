import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/social_repository.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final SocialRepository socialRepository;

  CreatePostBloc({required this.socialRepository}) : super(InitCreatePostState()) {
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
    Emitter<CreatePostState> emitter,
  ) async {
    emitter(TryCreatePostState());
    try {
      await socialRepository.createPost(
        title: event.title,
        content: event.content,
      );
      emitter(ResultCreatePostState());
    } catch (e) {
      emitter(ErrorCreatePostState(e.toString()));
    }
  }
}
