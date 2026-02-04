class UserMonthlyStats {
  final int totalEmotions;
  final double positiveRatio;
  final List<Map<String, dynamic>> emotionsPositive;
  final List<Map<String, dynamic>> areasPositive;

  UserMonthlyStats({
    required this.totalEmotions,
    required this.positiveRatio,
    required this.emotionsPositive,
    required this.areasPositive,
  });

  factory UserMonthlyStats.fromRpc(Map<String, dynamic> json) {
    // Estraiamo il nodo summary per comodità
    final summary = json['summary'] as Map<String, dynamic>? ?? {};

    return UserMonthlyStats(
      totalEmotions: summary['total_emotions'] ?? 0,
      positiveRatio: (summary['positive_ratio'] as num? ?? 0.0).toDouble(),
      emotionsPositive: List<Map<String, dynamic>>.from(
        json['emotions']?['positive'] ?? [],
      ),
      areasPositive: List<Map<String, dynamic>>.from(
        json['life_areas']?['positive'] ?? [],
      ),
    );
  }
}
