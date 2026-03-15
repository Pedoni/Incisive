import 'package:flame/components.dart';
import 'package:flame_lottie/flame_lottie.dart';
import 'package:flutter/material.dart';
import 'package:incisive/ui/components/base_room_game.dart';
import 'package:incisive/ui/components/clickable_object.dart';

class GardenGame extends BaseRoomGame {
  final VoidCallback onStatueTap;

  GardenGame({required this.onStatueTap});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final (:bgOrig, :bgTopLeft, :bgSize) = await setupBackground('garden_unity.png');

    final buddhaSprite = await loadSprite('buddha.png');

    final birds = Lottie.asset('assets/animations/birds.json');
    final birdsAnimation = await loadLottie(birds);

    add(
      LottieComponent(birdsAnimation, repeating: true)
        ..size = Vector2(size.x, size.y * 0.2)
        ..position = Vector2(0, size.y * 0.1),
    );

    final statue = ClickableObject(sprite: buddhaSprite, onTap: onStatueTap)
      ..anchor = Anchor.center
      ..size = buddhaSprite.originalSize * 0.09
      ..position = worldToScreen(
        anchorPx: Vector2(713, 1314),
        bgOrig: bgOrig,
        bgTopLeft: bgTopLeft,
        bgSize: bgSize,
      );
    add(statue);
  }
}