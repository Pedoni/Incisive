import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class BedroomGame extends FlameGame {
  BedroomGame({required this.onDiaryTap});

  final VoidCallback onDiaryTap;

  @override
  Future<void> onLoad() async {
    add(
      SpriteComponent(
        sprite: await loadSprite('bedroom_unity.png'),
        size: size,
      ),
    );

    add(
      DiaryComponent(
          sprite: await loadSprite('diary.png'),
          onTap: onDiaryTap,
        )
        ..size = Vector2(size.x * 0.12, size.x * 0.12)
        ..position = Vector2(size.x * 0.10, size.y * 0.503),
    );
  }
}

class DiaryComponent extends SpriteComponent with TapCallbacks {
  DiaryComponent({required super.sprite, required this.onTap});

  final VoidCallback onTap;

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }
}
