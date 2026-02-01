import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_lottie/flame_lottie.dart';
import 'package:incisive/ui/components/clickable_object.dart';

class GardenGame extends FlameGame {
  Vector2 worldSize = Vector2(390, 844);

  final VoidCallback onStatueTap;

  GardenGame({required this.onStatueTap});

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
    final bgSprite = await loadSprite('garden_unity.png');
    final buddhaSprite = await loadSprite('buddha.png');

    final birds = Lottie.asset('assets/animations/birds.json');
    final birdsAnimation = await loadLottie(birds);

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
    // UCCELLINI (effetto atmosferico)
    // ─────────────────────────────
    add(
      LottieComponent(
          birdsAnimation,
          repeating: true,
        )
        ..size = Vector2(
          size.x,
          size.y * 0.2,
        )
        ..position = Vector2(
          0,
          size.y * 0.1,
        ),
    );

    // ─────────────────────────────
    // STATUA — ancorata allo sfondo
    // ─────────────────────────────
    Vector2 statueAnchorPx = Vector2(
      713, // centro statua (x)
      1314, // centro statua (y)
    );

    final Vector2 statueNorm = Vector2(
      statueAnchorPx.x / bgOrig.x,
      statueAnchorPx.y / bgOrig.y,
    );

    final Vector2 statueScreenPos = Vector2(
      bgTopLeft.x + bg.size.x * statueNorm.x,
      bgTopLeft.y + bg.size.y * statueNorm.y,
    );

    final statue =
        ClickableObject(
            sprite: buddhaSprite,
            onTap: onStatueTap,
          )
          ..anchor = Anchor.center
          ..size = buddhaSprite.originalSize * 0.09
          ..position = statueScreenPos;

    add(statue);
  }
}
