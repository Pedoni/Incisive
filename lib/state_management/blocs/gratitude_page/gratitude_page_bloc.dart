import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/gratitude_page_model.dart';
import 'package:incisive/repositories/gratitude_repository.dart';

part 'gratitude_page_event.dart';
part 'gratitude_page_state.dart';

class GratitudePageBloc extends Bloc<GratitudePageEvent, GratitudePageState> {
  final GratitudeRepository gratitudeRepository;

  GratitudePageBloc({required this.gratitudeRepository}) : super(InitialGratitudeState()) {
    on<GetGratitudePageEvent>(_getGratitudePage);
  }

  void getGratitudePage(DateTime dateTime) => add(GetGratitudePageEvent(dateTime: dateTime));

  FutureOr<void> _getGratitudePage(
    GetGratitudePageEvent event,
    Emitter<GratitudePageState> emitter,
  ) async {
    emitter(LoadingGratitudeState());
    try {
      final entry = await gratitudeRepository.getPage(event.dateTime);
      emitter(entry != null && entry.list.isNotEmpty ? ResultGratitudeState(entry: entry) : EmptyGratitudeState());
    } catch (e) {
      emitter(ErrorGratitudeState(e.toString()));
    }
  }
}
