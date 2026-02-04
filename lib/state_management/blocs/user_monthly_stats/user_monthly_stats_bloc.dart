import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:incisive/models/reports/user_monthly_stats.dart';
import 'package:incisive/repositories/monthly_stats_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'user_monthly_stats_event.dart';

class UserMonthlyStatsBloc extends BaseBloc {
  final MonthlyStatsRepository monthlyStatsRepository;

  UserMonthlyStatsBloc({required this.monthlyStatsRepository}) : super(Initial()) {
    on<GetUserMonthlyStatsEvent>(_getUserMonthlyStats);
  }

  void getUserMonthlyStats(DateTime date) {
    add(GetUserMonthlyStatsEvent(month: date.month, year: date.year));
  }

  FutureOr<void> _getUserMonthlyStats(GetUserMonthlyStatsEvent event, Emitter<BaseState> emit) async {
    emit(Loading());
    try {
      final model = await monthlyStatsRepository.getUserMonthlyStats(
        month: event.month,
        year: event.year,
      );
      if (model.totalEmotions == 0) {
        emit(Empty());
      } else {
        emit(Success<UserMonthlyStats>(model));
      }
    } catch (e) {
      emit(Error(e.toString()));
    }
  }
}
