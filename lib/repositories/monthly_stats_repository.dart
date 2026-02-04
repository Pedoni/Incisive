import 'package:incisive/models/reports/user_monthly_stats.dart';
import 'package:incisive/repositories/base_repository.dart';
import 'package:incisive/source/remote/monthly_stats_service.dart';

class MonthlyStatsRepository extends BaseRepository {
  final MonthlyStatsService monthlyStatsService;

  MonthlyStatsRepository({required this.monthlyStatsService});

  Future<UserMonthlyStats> getUserMonthlyStats({
    required int month,
    required int year,
  }) async {
    return await guard(
      'Get diary page',
      () async {
        final map = await monthlyStatsService.getUserMonthlyStats(
          month: month,
          year: year,
        );
        return UserMonthlyStats.fromRpc(map!);
      },
    );
  }
}
