part of 'gratitude_upsert_bloc.dart';

sealed class GratitudeUpsertState extends Equatable {
  const GratitudeUpsertState();

  @override
  List<Object> get props => [];
}

final class InitialGratitudeUpsertState extends GratitudeUpsertState {}

final class LoadingUpsertPageState extends GratitudeUpsertState {}

final class ResultUpsertPageState extends GratitudeUpsertState {}

final class EmptyUpsertPageState extends GratitudeUpsertState {}

final class ErrorUpsertPageState extends GratitudeUpsertState {
  final String? errorString;
  const ErrorUpsertPageState(this.errorString);
}
