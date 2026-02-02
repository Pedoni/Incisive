part of 'avatar_bloc.dart';

sealed class AvatarEvent extends BaseEvent {
  const AvatarEvent();

  @override
  List<Object> get props => [];
}

class GetAvatarsEvent extends AvatarEvent {
  const GetAvatarsEvent();
}

class PurchaseAvatarEvent extends AvatarEvent {
  final String avatarId;

  const PurchaseAvatarEvent({required this.avatarId});
}

class EquipAvatarEvent extends AvatarEvent {
  final String avatarId;

  const EquipAvatarEvent({required this.avatarId});
}
