import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:incisive/ui/components/clickable_object.dart';

class GardenGame extends FlameGame {
  final VoidCallback onStatueTap;

  GardenGame({required this.onStatueTap});

  @override
  Future<void> onLoad() async {
    final background = await loadSprite('garden_unity.png');
    final buddhaSprite = await loadSprite('buddha.png');

    add(
      SpriteComponent(
        sprite: background,
        size: size,
      ),
    );

    add(
      ClickableObject(
          sprite: buddhaSprite,
          onTap: onStatueTap,
        )
        ..size = buddhaSprite.originalSize * 0.09
        ..position = Vector2(size.x * 0.5, size.y * 0.45),
    );
  }
}
