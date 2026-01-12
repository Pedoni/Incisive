part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfileEvent extends ProfileEvent {
  const GetProfileEvent();

  @override
  List<Object> get props => [];
}

class AddPointsEvent extends ProfileEvent {
  final int points;

  const AddPointsEvent({required this.points});

  @override
  List<Object> get props => [];
}
