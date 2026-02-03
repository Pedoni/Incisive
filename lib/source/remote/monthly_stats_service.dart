import 'package:incisive/source/remote/base_service.dart';
import 'package:incisive/utils/functions.dart';

class MonthlyStatsService extends BaseService {
  Future<JsonObject?> getUserMonthlyStats({
    required int month,
    required int year,
  }) async {
    return await guard(
      "Get diary page",
      () async {
        final response = await supabase.rpc(
          'get_user_monthly_stats',
          params: {
            'p_month': month,
            'p_year': year,
            'p_user_id': currentUserId,
          },
        );
        return response as JsonObject?;
      },
    );
  }
}
