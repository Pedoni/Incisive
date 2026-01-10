part of 'social_bloc.dart';

sealed class SocialEvent extends Equatable {
  const SocialEvent();

  @override
  List<Object?> get props => [];
}

class GetDailySocialPostsEvent extends SocialEvent {
  final DateTime date;

  const GetDailySocialPostsEvent(this.date);

  @override
  List<Object?> get props => [date];
}
