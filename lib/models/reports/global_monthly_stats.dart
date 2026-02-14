import 'package:incisive/models/reports/base_monthly_stats.dart';

class GlobalMonthlyStats extends BaseMonthlyStats {
  @override
  final int totalEmotions;

  @override
  final double positiveRatio;

  @override
  final List<Map<String, dynamic>> emotionsPositive;

  @override
  final List<Map<String, dynamic>> areasPositive;

  GlobalMonthlyStats({
    required this.totalEmotions,
    required this.positiveRatio,
    required this.emotionsPositive,
    required this.areasPositive,
  });

  factory GlobalMonthlyStats.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'];
    final emotions = json['emotions'];
    final areas = json['life_areas'];

    return GlobalMonthlyStats(
      totalEmotions: summary['total_emotions'] ?? 0,
      positiveRatio: (summary['positive_ratio'] as num?)?.toDouble() ?? 0.0,
      emotionsPositive: List<Map<String, dynamic>>.from(
        emotions['positive'] ?? [],
      ),
      areasPositive: List<Map<String, dynamic>>.from(
        areas['positive'] ?? [],
      ),
    );
  }
}
