part of 'upsert_page_bloc.dart';

sealed class UpsertPageState extends Equatable {
  const UpsertPageState();

  @override
  List<Object> get props => [];
}

class InitUpsertPageState extends UpsertPageState {
  const InitUpsertPageState();
}

class TryUpsertPageState extends UpsertPageState {
  const TryUpsertPageState();
}

class ResultUpsertPageState extends UpsertPageState {
  const ResultUpsertPageState();
}

class EmptyUpsertPageState extends UpsertPageState {
  const EmptyUpsertPageState();
}

class ErrorUpsertPageState extends UpsertPageState {
  final String? errorString;
  const ErrorUpsertPageState(this.errorString);
}
