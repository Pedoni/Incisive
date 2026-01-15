import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/user_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'profile_event.dart';

class ProfileBloc extends BaseBloc {
  final UserRepository userRepository;

  ProfileBloc({required this.userRepository}) : super(Initial()) {
    on<GetProfileEvent>(_getProfile);
    on<AddPointsEvent>(_addPoints);
  }

  void getProfile() => add(GetProfileEvent());

  void addPoints(int points) => add(AddPointsEvent(points: points));

  FutureOr<void> _getProfile(
    GetProfileEvent event,
    Emitter<BaseState> emitter,
  ) async {
    emitter(Loading());
    try {
      final user = await userRepository.getUser();
      emitter(Success(user));
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }

  FutureOr<void> _addPoints(
    AddPointsEvent event,
    Emitter<BaseState> emitter,
  ) async {
    emitter(Loading());
    try {
      await userRepository.addPoints(points: event.points);
      final user = await userRepository.getUser();
      emitter(Success(user));
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }
}
