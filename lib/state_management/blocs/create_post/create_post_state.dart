part of 'create_post_bloc.dart';

sealed class CreatePostState extends Equatable {
  const CreatePostState();

  @override
  List<Object> get props => [];
}

class InitCreatePostState extends CreatePostState {
  const InitCreatePostState();
}

class TryCreatePostState extends CreatePostState {
  const TryCreatePostState();
}

class ResultCreatePostState extends CreatePostState {
  const ResultCreatePostState();
}

class EmptyCreatePostState extends CreatePostState {
  const EmptyCreatePostState();
}

class ErrorCreatePostState extends CreatePostState {
  final String? errorString;
  const ErrorCreatePostState(this.errorString);
}
