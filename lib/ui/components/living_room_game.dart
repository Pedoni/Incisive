import 'dart:ui';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

class LivingRoomGame extends FlameGame {
  final VoidCallback onStereoTap;

  LivingRoomGame({required this.onStereoTap});

  @override
  Future<void> onLoad() async {
    add(
      SpriteComponent(
        sprite: await loadSprite('living_unity.png'),
        size: size,
      ),
    );

    add(
      StereoComponent(
          sprite: await loadSprite('radio.png'),
          onTap: onStereoTap,
        )
        ..size = Vector2(size.x * 0.15, size.x * 0.20)
        ..position = Vector2(size.x * 0.38, size.y * 0.535),
    );
  }
}

class StereoComponent extends SpriteComponent with TapCallbacks {
  StereoComponent({required super.sprite, required this.onTap});

  final VoidCallback onTap;

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }
}
