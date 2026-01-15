part of 'gratitude_page_bloc.dart';

sealed class GratitudePageEvent extends Equatable {
  const GratitudePageEvent();

  @override
  List<Object> get props => [];
}

class GetGratitudePageEvent extends GratitudePageEvent {
  final DateTime dateTime;

  const GetGratitudePageEvent({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}
