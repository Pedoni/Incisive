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
    final bg = await loadSprite('bedroom_unity.png');
    final diary = await loadSprite('diary.png');
    final cat = await loadSprite('sleeping_cat.png');

    // Background
    add(
      SpriteComponent(
        sprite: bg,
        size: size,
      ),
    );

    // Diario
    add(
      ClickableObject(
          sprite: diary,
          onTap: onDiaryTap,
        )
        ..size = Vector2(size.x * 0.12, size.x * 0.12)
        ..position = Vector2(size.x * 0.10, size.y * 0.50),
    );

    // OMBRA (finta ma giusta)
    add(
      RectangleComponent(
        size: Vector2(size.x * 0.22, size.x * 0.04),
        position: Vector2(
          size.x * 0.20,
          size.y * 0.78,
        ),
        paint:
            Paint()
              ..color = Colors.black.withValues(alpha: 0.18)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
      ),
    );

    // Gatto
    add(
      ClickableObject(
          sprite: cat,
          onTap: onPetTap,
        )
        ..size = Vector2(size.x * 0.28, size.x * 0.28)
        ..position = Vector2(size.x * 0.16, size.y * 0.68),
    );
  }
}
