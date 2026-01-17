part of 'upsert_page_bloc.dart';

class TryUpsertPageEvent extends BaseEvent {
  final DateTime dateTime;
  final String text;

  const TryUpsertPageEvent({
    required this.dateTime,
    required this.text,
  });

  @override
  List<Object> get props => [dateTime];
}
