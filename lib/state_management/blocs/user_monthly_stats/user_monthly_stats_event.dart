part of 'user_monthly_stats_bloc.dart';

final class GetUserMonthlyStatsEvent extends BaseEvent {
  final int month;
  final int year;

  const GetUserMonthlyStatsEvent({
    required this.month,
    required this.year,
  });

  @override
  List<Object> get props => [month, year];
}
