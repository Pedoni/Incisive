import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:incisive/ui/components/clickable_object.dart';

class BedroomGame extends FlameGame {
  // Mondo logico di riferimento (iPhone-like)
  Vector2 worldSize = Vector2(390, 844);

  final VoidCallback onDiaryTap;
  final VoidCallback onPetTap;

  BedroomGame({
    required this.onDiaryTap,
    required this.onPetTap,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // ─────────────────────────────
    // CAMERA: mondo stabile
    // ─────────────────────────────
    camera.viewfinder
      ..anchor = Anchor.topLeft
      ..visibleGameSize = worldSize;

    // ─────────────────────────────
    // ASSET
    // ─────────────────────────────
    final bgSprite = await loadSprite('bedroom_unity.png');
    final diarySprite = await loadSprite('diary.png');
    final catSprite = await loadSprite('sleeping_cat.png');

    // ─────────────────────────────
    // BACKGROUND FULLSCREEN (cover)
    // ─────────────────────────────
    final bg = SpriteComponent(
      sprite: bgSprite,
      anchor: Anchor.center,
    );

    final screenRatio = size.x / size.y;
    final bgRatio = bgSprite.originalSize.x / bgSprite.originalSize.y;

    if (bgRatio > screenRatio) {
      bg.size = Vector2(size.y * bgRatio, size.y);
    } else {
      bg.size = Vector2(size.x, size.x / bgRatio);
    }

    bg.position = size / 2;
    add(bg);

    // Coordinate utili
    final Vector2 bgOrig = bgSprite.originalSize;
    final Vector2 bgTopLeft = bg.position - bg.size / 2;

    // ─────────────────────────────
    // DIARIO — ancorato al comodino
    // ─────────────────────────────
    Vector2 diaryAnchorPx = Vector2(
      179, // centro comodino (x)
      1358, // centro comodino (y)
    );

    final Vector2 diaryNorm = Vector2(
      diaryAnchorPx.x / bgOrig.x,
      diaryAnchorPx.y / bgOrig.y,
    );

    final Vector2 diaryScreenPos = Vector2(
      bgTopLeft.x + bg.size.x * diaryNorm.x,
      bgTopLeft.y + bg.size.y * diaryNorm.y,
    );

    final diary =
        ClickableObject(
            sprite: diarySprite,
            onTap: onDiaryTap,
          )
          ..anchor = Anchor.center
          ..size = Vector2(
            worldSize.x * 0.12,
            worldSize.x * 0.12,
          )
          ..position = diaryScreenPos;

    add(diary);

    // ─────────────────────────────
    // OMBRA (decorativa)
    // ─────────────────────────────
    add(
      RectangleComponent(
        size: Vector2(
          worldSize.x * 0.22,
          worldSize.x * 0.04,
        ),
        position: Vector2(
          worldSize.x * 0.20,
          worldSize.y * 0.78,
        ),
        paint:
            Paint()
              ..color = Colors.black.withValues(alpha: 0.18)
              ..maskFilter = const MaskFilter.blur(
                BlurStyle.normal,
                18,
              ),
      ),
    );

    // ─────────────────────────────
    // GATTO — ancorato al pavimento
    // ─────────────────────────────
    Vector2 catAnchorPx = Vector2(
      433, // centro zona pavimento (x)
      1880, // centro zona pavimento (y)
    );

    final Vector2 catNorm = Vector2(
      catAnchorPx.x / bgOrig.x,
      catAnchorPx.y / bgOrig.y,
    );

    final Vector2 catScreenPos = Vector2(
      bgTopLeft.x + bg.size.x * catNorm.x,
      bgTopLeft.y + bg.size.y * catNorm.y,
    );

    final cat =
        ClickableObject(
            sprite: catSprite,
            onTap: onPetTap,
          )
          ..anchor = Anchor.center
          ..size = Vector2(
            worldSize.x * 0.28,
            worldSize.x * 0.28,
          )
          ..position = catScreenPos;

    add(cat);
  }
}
