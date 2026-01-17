part of 'profile_bloc.dart';

class GetProfileEvent extends BaseEvent {
  const GetProfileEvent();

  @override
  List<Object> get props => [];
}

class AddPointsEvent extends BaseEvent {
  final int points;

  const AddPointsEvent({required this.points});

  @override
  List<Object> get props => [];
}
