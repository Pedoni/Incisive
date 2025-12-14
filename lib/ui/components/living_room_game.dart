import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:incisive/ui/components/clickable_object.dart';

class LivingRoomGame extends FlameGame {
  final VoidCallback onStereoTap;

  LivingRoomGame({required this.onStereoTap});

  @override
  Future<void> onLoad() async {
    final background = await loadSprite('living_unity.png');
    final stereoSprite = await loadSprite('echodot.png');

    add(
      SpriteComponent(
        sprite: background,
        size: size,
      ),
    );

    add(
      ClickableObject(
          sprite: stereoSprite,
          onTap: onStereoTap,
        )
        ..size = stereoSprite.originalSize * 0.039
        ..position = Vector2(size.x * 0.42, size.y * 0.565),
    );
  }
}
