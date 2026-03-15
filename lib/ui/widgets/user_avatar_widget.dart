import 'package:flutter/material.dart';
import 'package:incisive/utils/functions.dart';

class UserAvatarWidget extends StatelessWidget {
  final String avatarAsset;
  final int level;
  final double radius;

  const UserAvatarWidget({
    super.key,
    required this.avatarAsset,
    required this.level,
    this.radius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Image.asset('assets/images/$avatarAsset'),
          ),
        );
      },
      child: CircleAvatar(
        radius: radius,
        backgroundColor: getUserBackgroundColor(level),
        child: ClipOval(
          child: Image.asset(
            'assets/images/$avatarAsset',
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Icon(Icons.person, size: radius),
          ),
        ),
      ),
    );
  }
}