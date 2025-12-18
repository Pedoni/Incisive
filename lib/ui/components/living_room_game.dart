import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:incisive/ui/components/clickable_object.dart';

class LivingRoomGame extends FlameGame {
  final VoidCallback onBlackboardTap;

  LivingRoomGame({required this.onBlackboardTap});

  @override
  Future<void> onLoad() async {
    final background = await loadSprite('living_unity.png');
    final blackboardSprite = await loadSprite('blackboard.png');

    add(
      SpriteComponent(
        sprite: background,
        size: size,
      ),
    );

    add(
      ClickableObject(
          sprite: blackboardSprite,
          onTap: onBlackboardTap,
        )
        ..size = blackboardSprite.originalSize * 0.28
        ..position = Vector2(size.x * 0.48, size.y * 0.25),
    );
  }
}
