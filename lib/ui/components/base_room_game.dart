import 'package:flame/components.dart';
import 'package:flame/game.dart';

abstract class BaseRoomGame extends FlameGame {
  Vector2 get worldSize => Vector2(390, 844);

  /// Configura la camera, carica lo sfondo e restituisce bgOrig, bgTopLeft, bgSize.
  Future<({Vector2 bgOrig, Vector2 bgTopLeft, Vector2 bgSize})> setupBackground(
    String assetName,
  ) async {
    camera.viewfinder
      ..anchor = Anchor.topLeft
      ..visibleGameSize = worldSize;

    final bgSprite = await loadSprite(assetName);
    final bg = SpriteComponent(sprite: bgSprite, anchor: Anchor.center);

    final screenRatio = size.x / size.y;
    final bgRatio = bgSprite.originalSize.x / bgSprite.originalSize.y;

    if (bgRatio > screenRatio) {
      bg.size = Vector2(size.y * bgRatio, size.y);
    } else {
      bg.size = Vector2(size.x, size.x / bgRatio);
    }

    bg.position = size / 2;
    add(bg);

    return (
      bgOrig: bgSprite.originalSize,
      bgTopLeft: bg.position - bg.size / 2,
      bgSize: bg.size,
    );
  }

  /// Converte coordinate pixel dell'immagine originale in posizione schermo.
  Vector2 worldToScreen({
    required Vector2 anchorPx,
    required Vector2 bgOrig,
    required Vector2 bgTopLeft,
    required Vector2 bgSize,
  }) {
    final norm = Vector2(anchorPx.x / bgOrig.x, anchorPx.y / bgOrig.y);
    return Vector2(
      bgTopLeft.x + bgSize.x * norm.x,
      bgTopLeft.y + bgSize.y * norm.y,
    );
  }
}