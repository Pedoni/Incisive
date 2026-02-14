import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/reports/global_monthly_stats.dart';
import 'package:incisive/repositories/monthly_stats_repository.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';

part 'global_monthly_stats_event.dart';

class GlobalMonthlyStatsBloc extends BaseBloc {
  final MonthlyStatsRepository monthlyStatsRepository;

  GlobalMonthlyStatsBloc({required this.monthlyStatsRepository}) : super(Initial()) {
    on<GetGlobalMonthlyStatsEvent>(_getGlobalMonthlyStats);
  }

  void getGlobalMonthlyStats(DateTime date) {
    add(GetGlobalMonthlyStatsEvent(month: date.month, year: date.year));
  }

  FutureOr<void> _getGlobalMonthlyStats(GetGlobalMonthlyStatsEvent event, Emitter<BaseState> emit) async {
    emit(Loading());
    try {
      final model = await monthlyStatsRepository.getGlobalMonthlyStats(
        month: event.month,
        year: event.year,
      );

      if (model == null || model.totalEmotions == 0) {
        emit(Empty());
      } else {
        emit(Success<GlobalMonthlyStats>(model));
      }
    } catch (e) {
      emit(Error(e.toString()));
    }
  }
}
