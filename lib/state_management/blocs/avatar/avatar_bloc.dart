import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/user_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'avatar_event.dart';

class AvatarBloc extends BaseBloc {
  final UserRepository userRepository;

  AvatarBloc({required this.userRepository}) : super(Initial()) {
    on<GetAvatarsEvent>(_getAvatarsEvent);
    on<PurchaseAvatarEvent>(_purchaseAvatarEvent);
    on<EquipAvatarEvent>(_equipAvatarEvent);
  }

  void getAvatars() => add(const GetAvatarsEvent());

  void purchase(String id) => add(PurchaseAvatarEvent(avatarId: id));

  void equip(String id) => add(EquipAvatarEvent(avatarId: id));

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

  Future<void> _purchaseAvatarEvent(
    PurchaseAvatarEvent event,
    Emitter<BaseState> emitter,
  ) async {
    emitter(Loading());
    try {
      await userRepository.purchaseAvatar(event.avatarId);
      final avatars = await userRepository.getAvatars();
      emitter(Success(avatars));
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }

  Future<void> _equipAvatarEvent(
    EquipAvatarEvent event,
    Emitter<BaseState> emitter,
  ) async {
    emitter(Loading());
    try {
      await userRepository.equipAvatar(event.avatarId);
      final avatars = await userRepository.getAvatars();
      emitter(Success(avatars));
    } catch (e) {
      emitter(Error(e.toString()));
    }
  }
}
