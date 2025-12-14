import 'package:flame/game.dart';
import 'package:flame/components.dart';

class GardenGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    // Background full screen
    add(
      SpriteComponent(
        sprite: await loadSprite('garden_unity.png'),
        size: size,
      ),
    );
  }
}
