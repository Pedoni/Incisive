import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:incisive/ui/components/base_room_game.dart';
import 'package:incisive/ui/components/clickable_object.dart';

class LivingRoomGame extends BaseRoomGame {
  final VoidCallback onBlackboardTap;

  LivingRoomGame({required this.onBlackboardTap});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final (:bgOrig, :bgTopLeft, :bgSize) = await setupBackground('living_unity.png');

    final blackboardSprite = await loadSprite('blackboard.png');

    final blackboard = ClickableObject(sprite: blackboardSprite, onTap: onBlackboardTap)
      ..anchor = Anchor.center
      ..size = blackboardSprite.originalSize * 0.28
      ..position = worldToScreen(
        anchorPx: Vector2(826, 882),
        bgOrig: bgOrig,
        bgTopLeft: bgTopLeft,
        bgSize: bgSize,
      );
    add(blackboard);
  }
}