part of 'gratitude_upsert_bloc.dart';

class TryUpsertGratitudeEvent extends BaseEvent {
  final String? pageId;
  final List<String> texts;

  const TryUpsertGratitudeEvent({
    required this.pageId,
    required this.texts,
  });

  @override
  List<Object?> get props => [pageId, texts];
}
