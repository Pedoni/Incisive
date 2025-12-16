import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;

  ProfileBloc({required this.userRepository}) : super(InitialProfileState()) {
    on<GetProfileEvent>(_getProfile);
  }

  void getProfile() => add(GetProfileEvent());

  FutureOr<void> _getProfile(
    GetProfileEvent event,
    Emitter<ProfileState> emitter,
  ) async {
    emitter(LoadingProfileState());
    try {
      await userRepository.getUser();
      emitter(ResultProfileState());
    } catch (e) {
      emitter(ErrorProfileState(e.toString()));
    }
  }
}
