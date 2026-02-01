import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:incisive/ui/components/clickable_object.dart';

class LivingRoomGame extends FlameGame {
  Vector2 worldSize = Vector2(390, 844);

  final VoidCallback onBlackboardTap;

  LivingRoomGame({required this.onBlackboardTap});

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
    final bgSprite = await loadSprite('living_unity.png');
    final blackboardSprite = await loadSprite('blackboard.png');

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
    // LAVAGNA — ancorata allo sfondo
    // ─────────────────────────────
    Vector2 blackboardAnchorPx = Vector2(
      826, // centro lavagna (x)
      882, // centro lavagna (y)
    );

    final Vector2 blackboardNorm = Vector2(
      blackboardAnchorPx.x / bgOrig.x,
      blackboardAnchorPx.y / bgOrig.y,
    );

    final Vector2 blackboardScreenPos = Vector2(
      bgTopLeft.x + bg.size.x * blackboardNorm.x,
      bgTopLeft.y + bg.size.y * blackboardNorm.y,
    );

    final blackboard =
        ClickableObject(
            sprite: blackboardSprite,
            onTap: onBlackboardTap,
          )
          ..anchor = Anchor.center
          ..size = blackboardSprite.originalSize * 0.28
          ..position = blackboardScreenPos;

    add(blackboard);
  }
}
