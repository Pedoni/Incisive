part of 'gratitude_upsert_bloc.dart';

sealed class GratitudeUpsertEvent extends Equatable {
  const GratitudeUpsertEvent();

  @override
  List<Object> get props => [];
}

class TryUpsertGratitudeEvent extends GratitudeUpsertEvent {
  final String pageId;
  final List<String> texts;

  const TryUpsertGratitudeEvent({
    required this.pageId,
    required this.texts,
  });

  @override
  List<Object> get props => [pageId, texts];
}
