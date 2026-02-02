import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/user_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'avatar_event.dart';

class AvatarBloc extends BaseBloc {
  final UserRepository userRepository;

  AvatarBloc({required this.userRepository}) : super(Initial()) {
    on<GetAvatarsEvent>(_getAvatarsEvent);
  }

  void getAvatars() => add(const GetAvatarsEvent());

  Future<void> _getAvatarsEvent(
    GetAvatarsEvent event,
    Emitter<BaseState> emitter,
  ) async {
    emitter(Loading());
    try {
      final avatars = await userRepository.getAvatars();
      emitter(Success(avatars));
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }
}
