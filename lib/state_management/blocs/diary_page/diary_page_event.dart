part of 'diary_page_bloc.dart';

class TryDiaryPageEvent extends BaseEvent {
  final DateTime dateTime;

  const TryDiaryPageEvent({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class UpdateDiaryPrivacyEvent extends BaseEvent {
  final DateTime date;
  final bool isPrivate;
  const UpdateDiaryPrivacyEvent({required this.date, required this.isPrivate});

  @override
  List<Object> get props => [date, isPrivate];
}
