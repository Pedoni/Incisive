part of 'diary_page_bloc.dart';

abstract class DiaryPageEvent {
  const DiaryPageEvent();

  @override
  List<Object> get props => [];
}

class TryDiaryPageEvent extends DiaryPageEvent {
  final DateTime dateTime;

  const TryDiaryPageEvent({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}
