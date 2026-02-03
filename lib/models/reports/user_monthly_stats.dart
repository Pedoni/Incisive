class UserMonthlyStats {
  final int totalEmotions;
  final double positiveRatio;
  final List<Map<String, dynamic>> emotionsPositive;
  final List<Map<String, dynamic>> areasPositive;

  UserMonthlyStats.fromRpc(Map<String, dynamic> json)
    : totalEmotions = json['summary']['total_emotions'],
      positiveRatio = (json['summary']['positive_ratio'] as num).toDouble(),
      emotionsPositive = List<Map<String, dynamic>>.from(json['emotions']['positive']),
      areasPositive = List<Map<String, dynamic>>.from(json['life_areas']['positive']);
}
