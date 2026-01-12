import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/user_model.dart';
import 'package:incisive/repositories/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;

  ProfileBloc({required this.userRepository}) : super(InitialProfileState()) {
    on<GetProfileEvent>(_getProfile);
    on<AddPointsEvent>(_addPoints);
  }

  void getProfile() => add(GetProfileEvent());

  void addPoints(int points) => add(AddPointsEvent(points: points));

  FutureOr<void> _getProfile(
    GetProfileEvent event,
    Emitter<ProfileState> emitter,
  ) async {
    emitter(LoadingProfileState());
    try {
      final user = await userRepository.getUser();
      emitter(ResultProfileState(user));
    } catch (e) {
      emitter(ErrorProfileState(e.toString()));
    }
  }

  FutureOr<void> _addPoints(
    AddPointsEvent event,
    Emitter<ProfileState> emitter,
  ) async {
    emitter(LoadingProfileState());
    try {
      await userRepository.addPoints(points: event.points);
      final user = await userRepository.getUser();
      emitter(ResultProfileState(user));
    } catch (e) {
      emitter(ErrorProfileState(e.toString()));
    }
  }
}
