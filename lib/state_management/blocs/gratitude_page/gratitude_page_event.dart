part of 'gratitude_page_bloc.dart';

class GetGratitudePageEvent extends BaseEvent {
  final DateTime dateTime;

  const GetGratitudePageEvent({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}
