import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:incisive/repositories/gratitude_repository.dart';

part 'gratitude_upsert_event.dart';
part 'gratitude_upsert_state.dart';

class GratitudeUpsertBloc extends Bloc<GratitudeUpsertEvent, GratitudeUpsertState> {
  final GratitudeRepository gratitudeRepository;

  GratitudeUpsertBloc({required this.gratitudeRepository}) : super(InitialGratitudeUpsertState()) {
    on<TryUpsertGratitudeEvent>(_upsertGratitude);
  }

  void upsertGratitude(
    String pageId,
    List<String> texts,
  ) => add(
    TryUpsertGratitudeEvent(
      pageId: pageId,
      texts: texts,
    ),
  );

  FutureOr<void> _upsertGratitude(
    TryUpsertGratitudeEvent event,
    Emitter<GratitudeUpsertState> emitter,
  ) async {
    emitter(LoadingUpsertPageState());
    try {
      await gratitudeRepository.upsertPage(pageId: event.pageId, texts: event.texts);
      emitter(ResultUpsertPageState());
    } catch (e) {
      emitter(ErrorUpsertPageState(e.toString()));
    }
  }
}
