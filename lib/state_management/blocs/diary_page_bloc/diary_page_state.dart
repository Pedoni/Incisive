part of 'diary_page_bloc.dart';

abstract class DiaryPageState extends Equatable {
  const DiaryPageState();

  @override
  List<Object> get props => [];
}

class InitDiaryPageState extends DiaryPageState {
  const InitDiaryPageState();
}

class TryDiaryPageState extends DiaryPageState {
  const TryDiaryPageState();
}

class ResultDiaryPageState extends DiaryPageState {
  const ResultDiaryPageState();
}

class EmptyDiaryPageState extends DiaryPageState {
  const EmptyDiaryPageState();
}

class ErrorDiaryPageState extends DiaryPageState {
  final String? errorString;
  const ErrorDiaryPageState(this.errorString);
}
