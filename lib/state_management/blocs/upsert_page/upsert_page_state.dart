part of 'upsert_page_bloc.dart';

sealed class UpsertPageState extends Equatable {
  const UpsertPageState();

  @override
  List<Object> get props => [];
}

final class InitUpsertPageState extends UpsertPageState {}

final class TryUpsertPageState extends UpsertPageState {}

final class ResultUpsertPageState extends UpsertPageState {}

final class EmptyUpsertPageState extends UpsertPageState {}

final class ErrorUpsertPageState extends UpsertPageState {
  final String? errorString;
  const ErrorUpsertPageState(this.errorString);
}
