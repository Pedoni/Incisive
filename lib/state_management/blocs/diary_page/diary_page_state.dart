part of 'diary_page_bloc.dart';

sealed class DiaryPageState extends Equatable {
  const DiaryPageState();

  @override
  List<Object> get props => [];
}

final class InitDiaryPageState extends DiaryPageState {}

final class TryDiaryPageState extends DiaryPageState {}

final class ResultDiaryPageState extends DiaryPageState {
  final DiaryEntry entry;
  const ResultDiaryPageState({required this.entry});
}

final class EmptyDiaryPageState extends DiaryPageState {}

final class ErrorDiaryPageState extends DiaryPageState {
  final String? errorString;
  const ErrorDiaryPageState(this.errorString);
}
