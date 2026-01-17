part of 'create_post_bloc.dart';

final class TryCreatePostEvent extends BaseEvent {
  final String content;
  final String title;

  const TryCreatePostEvent({
    required this.content,
    required this.title,
  });

  @override
  List<Object> get props => [content, title];
}
