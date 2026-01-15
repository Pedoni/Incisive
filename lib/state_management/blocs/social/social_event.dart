part of 'social_bloc.dart';

class GetDailySocialPostsEvent extends BaseEvent {
  final DateTime date;

  const GetDailySocialPostsEvent(this.date);

  @override
  List<Object?> get props => [date];
}
