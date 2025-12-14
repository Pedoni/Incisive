import 'package:flame/game.dart';
import 'package:flame/components.dart';

class LivingRoomGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    add(
      SpriteComponent(
        sprite: await loadSprite('living_unity.png'),
        size: size,
      ),
    );
  }
}
