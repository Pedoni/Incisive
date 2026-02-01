import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:incisive/ui/components/clickable_object.dart';

class SquareGame extends FlameGame {
  final VoidCallback onBulletinBoardTap;
  SquareGame({required this.onBulletinBoardTap});

  @override
  Future<void> onLoad() async {
    final bgSprite = await loadSprite('square.png');
    final overlaySprite = await loadSprite('bulletin_board.png');

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

    const Rect whiteBoardPx = Rect.fromLTWH(
      411,
      1166,
      348,
      177,
    );

    final bgOrig = bgSprite.originalSize;

    final Rect whiteBoardNorm = Rect.fromLTWH(
      whiteBoardPx.left / bgOrig.x,
      whiteBoardPx.top / bgOrig.y,
      whiteBoardPx.width / bgOrig.x,
      whiteBoardPx.height / bgOrig.y,
    );

    final Vector2 bgTopLeft = bg.position - bg.size / 2;

    final Rect whiteBoardScreen = Rect.fromLTWH(
      bgTopLeft.x + bg.size.x * whiteBoardNorm.left,
      bgTopLeft.y + bg.size.y * whiteBoardNorm.top,
      bg.size.x * whiteBoardNorm.width,
      bg.size.y * whiteBoardNorm.height,
    );

    final overlay =
        ClickableObject(
            sprite: overlaySprite,
            onTap: onBulletinBoardTap,
          )
          ..size = Vector2(
            whiteBoardScreen.width,
            whiteBoardScreen.height,
          )
          ..position = Vector2(
            whiteBoardScreen.left,
            whiteBoardScreen.top,
          );

    add(overlay);
  }
}
