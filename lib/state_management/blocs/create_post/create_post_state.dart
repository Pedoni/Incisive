part of 'create_post_bloc.dart';

sealed class CreatePostState extends Equatable {
  const CreatePostState();

  @override
  List<Object> get props => [];
}

final class InitCreatePostState extends CreatePostState {}

final class TryCreatePostState extends CreatePostState {}

final class ResultCreatePostState extends CreatePostState {}

final class EmptyCreatePostState extends CreatePostState {}

final class ErrorCreatePostState extends CreatePostState {
  final String? errorString;
  const ErrorCreatePostState(this.errorString);
}
