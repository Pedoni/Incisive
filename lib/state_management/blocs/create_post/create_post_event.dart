part of 'create_post_bloc.dart';

sealed class CreatePostEvent {
  const CreatePostEvent();

  List<Object> get props => [];
}

class TryCreatePostEvent extends CreatePostEvent {
  final String content;
  final String title;

  const TryCreatePostEvent({
    required this.content,
    required this.title,
  });

  @override
  List<Object> get props => [content, title];
}
