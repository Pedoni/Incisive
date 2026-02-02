import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/repositories/user_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'purchase_event.dart';

class PurchaseBloc extends BaseBloc {
  final UserRepository userRepository;

  PurchaseBloc({required this.userRepository}) : super(Initial()) {
    on<PurchaseAvatarEvent>(_onPurchaseAvatarEvent);
    on<EquipAvatarEvent>(_onEquipAvatarEvent);
  }

  void purchaseAvatar(String avatarId) {
    add(PurchaseAvatarEvent(avatarId));
  }

  void equipAvatar(String avatarId) {
    add(EquipAvatarEvent(avatarId));
  }

  Future<void> _onPurchaseAvatarEvent(
    PurchaseAvatarEvent event,
    Emitter<BaseState> emit,
  ) async {
    emit(Loading());
    try {
      await userRepository.purchaseAvatar(event.avatarId);
      emit(Success(event.avatarId));
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  Future<void> _onEquipAvatarEvent(
    EquipAvatarEvent event,
    Emitter<BaseState> emit,
  ) async {
    emit(Loading());
    try {
      await userRepository.equipAvatar(event.avatarId);
      emit(Success(event.avatarId));
    } catch (e) {
      emit(Error(e.toString()));
    }
  }
}
