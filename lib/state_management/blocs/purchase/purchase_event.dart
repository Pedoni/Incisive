part of 'purchase_bloc.dart';

sealed class PurchaseEvent extends BaseEvent {
  const PurchaseEvent();

  @override
  List<Object> get props => [];
}

class PurchaseAvatarEvent extends PurchaseEvent {
  final String avatarId;

  const PurchaseAvatarEvent(this.avatarId);

  @override
  List<Object> get props => [avatarId];
}

class EquipAvatarEvent extends PurchaseEvent {
  final String avatarId;

  const EquipAvatarEvent(this.avatarId);

  @override
  List<Object> get props => [avatarId];
}
