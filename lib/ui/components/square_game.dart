import 'package:flame/game.dart';
import 'package:flame/components.dart';

class SquareGame extends FlameGame {
  SquareGame();

  @override
  Future<void> onLoad() async {
    add(
      SpriteComponent(
        sprite: await loadSprite('square.png'),
        size: size,
      ),
    );
  }
}
