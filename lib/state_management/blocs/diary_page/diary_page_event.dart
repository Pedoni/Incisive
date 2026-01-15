part of 'diary_page_bloc.dart';

class TryDiaryPageEvent extends BaseEvent {
  final DateTime dateTime;

  const TryDiaryPageEvent({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}
