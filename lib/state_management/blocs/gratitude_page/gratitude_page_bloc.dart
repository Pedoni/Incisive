import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/gratitude_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'gratitude_page_event.dart';

class GratitudePageBloc extends BaseBloc {
  final GratitudeRepository gratitudeRepository;

  GratitudePageBloc({required this.gratitudeRepository}) : super(Initial()) {
    on<GetGratitudePageEvent>(_getGratitudePage);
  }

  void getGratitudePage(DateTime dateTime) => add(GetGratitudePageEvent(dateTime: dateTime));

  FutureOr<void> _getGratitudePage(
    GetGratitudePageEvent event,
    Emitter<BaseState> emitter,
  ) async {
    emitter(Loading());
    try {
      final entry = await gratitudeRepository.getPage(event.dateTime);
      emitter(entry.list!.isNotEmpty ? Success(entry) : Empty(data: entry));
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }
}
