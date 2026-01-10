import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:incisive/ui/components/clickable_object.dart';

class SquareGame extends FlameGame {
  final VoidCallback onBulletinBoardTap;
  SquareGame({required this.onBulletinBoardTap});

  @override
  Future<void> onLoad() async {
    final background = await loadSprite('square.png');
    final bulletinSprite = await loadSprite('bulletin_board.png');

    add(
      SpriteComponent(
        sprite: background,
        size: size,
      ),
    );

    add(
      ClickableObject(
          sprite: bulletinSprite,
          onTap: onBulletinBoardTap,
        )
        ..size = Vector2(bulletinSprite.originalSize.x * 0.083, size.x * 0.14)
        ..position = Vector2(size.x * 0.35, size.y * 0.46),
    );
  }
}
