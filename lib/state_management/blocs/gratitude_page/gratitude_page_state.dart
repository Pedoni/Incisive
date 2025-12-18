part of 'gratitude_page_bloc.dart';

sealed class GratitudePageState extends Equatable {
  const GratitudePageState();

  @override
  List<Object> get props => [];
}

final class InitialGratitudeState extends GratitudePageState {}

final class LoadingGratitudeState extends GratitudePageState {}

final class EmptyGratitudeState extends GratitudePageState {}

final class ResultGratitudeState extends GratitudePageState {
  final GratitudePageModel entry;
  const ResultGratitudeState({required this.entry});
}

final class ErrorGratitudeState extends GratitudePageState {
  final String? errorString;

  const ErrorGratitudeState(this.errorString);
}
