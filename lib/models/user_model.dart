class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final int points;
  final int level;
  final double progress;
  final int nextLevelPoints;
  final int spentPoints;
  final String avatarAsset;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.points,
    required this.level,
    required this.progress,
    required this.nextLevelPoints,
    required this.spentPoints,
    required this.avatarAsset,
  });
}
