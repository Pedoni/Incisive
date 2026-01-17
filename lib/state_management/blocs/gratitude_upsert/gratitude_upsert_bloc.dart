import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:incisive/repositories/gratitude_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'gratitude_upsert_event.dart';

class GratitudeUpsertBloc extends BaseBloc {
  final GratitudeRepository gratitudeRepository;

  GratitudeUpsertBloc({required this.gratitudeRepository}) : super(Initial()) {
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
    Emitter<BaseState> emitter,
  ) async {
    emitter(Loading());
    try {
      await gratitudeRepository.upsertPage(pageId: event.pageId, texts: event.texts);
      emitter(Success<void>(null));
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }
}
