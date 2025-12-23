import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:incisive/ui/components/clickable_object.dart';

class BedroomGame extends FlameGame {
  final VoidCallback onDiaryTap;
  final VoidCallback onPetTap;

  BedroomGame({
    required this.onDiaryTap,
    required this.onPetTap,
  });

  @override
  Future<void> onLoad() async {
    add(
      SpriteComponent(
        sprite: await loadSprite('bedroom_unity.png'),
        size: size,
      ),
    );

    add(
      ClickableObject(
          sprite: await loadSprite('diary.png'),
          onTap: onDiaryTap,
        )
        ..size = Vector2(size.x * 0.12, size.x * 0.12)
        ..position = Vector2(size.x * 0.10, size.y * 0.503),
    );

    add(
      ClickableObject(
          sprite: await loadSprite('sleeping_cat.png'),
          onTap: onPetTap,
        )
        ..size = Vector2(size.x * 0.30, size.x * 0.30)
        ..position = Vector2(size.x * 0.16, size.y * 0.70),
    );
  }
}
