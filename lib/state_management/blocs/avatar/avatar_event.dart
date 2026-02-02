part of 'avatar_bloc.dart';

sealed class AvatarEvent extends BaseEvent {
  const AvatarEvent();

  @override
  List<Object> get props => [];
}

class GetAvatarsEvent extends AvatarEvent {
  final String userId;

  const GetAvatarsEvent({required this.userId});
}
