class AvatarModel {
  final String id;
  final String name;
  final int cost;
  final String asset;
  final bool owned;
  final bool equipped;

  AvatarModel({
    required this.id,
    required this.name,
    required this.cost,
    required this.asset,
    required this.owned,
    required this.equipped,
  });

  factory AvatarModel.fromJson(Map<String, dynamic> json) {
    return AvatarModel(
      id: json['id'],
      name: json['name'],
      cost: json['cost'],
      asset: json['asset'],
      owned: json['owned'] ?? false,
      equipped: json['equipped'] ?? false,
    );
  }
}
