part of 'global_monthly_stats_bloc.dart';

final class GetGlobalMonthlyStatsEvent extends BaseEvent {
  final int month;
  final int year;

  const GetGlobalMonthlyStatsEvent({
    required this.month,
    required this.year,
  });

  @override
  List<Object> get props => [month, year];
}
