part of 'upsert_page_bloc.dart';

abstract class UpsertPageEvent {
  const UpsertPageEvent();

  List<Object> get props => [];
}

class TryUpsertPageEvent extends UpsertPageEvent {
  final DateTime dateTime;
  final String text;

  const TryUpsertPageEvent({
    required this.dateTime,
    required this.text,
  });

  @override
  List<Object> get props => [dateTime];
}
