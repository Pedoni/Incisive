import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:incisive/ui/components/base_room_game.dart';
import 'package:incisive/ui/components/clickable_object.dart';

class BedroomGame extends BaseRoomGame {
  final VoidCallback onDiaryTap;
  final VoidCallback onPetTap;

  BedroomGame({
    required this.onDiaryTap,
    required this.onPetTap,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final (:bgOrig, :bgTopLeft, :bgSize) = await setupBackground('bedroom_unity.png');

    final diarySprite = await loadSprite('diary.png');
    final catSprite = await loadSprite('sleeping_cat.png');

    final diary = ClickableObject(sprite: diarySprite, onTap: onDiaryTap)
      ..anchor = Anchor.center
      ..size = Vector2(worldSize.x * 0.12, worldSize.x * 0.12)
      ..position = worldToScreen(
        anchorPx: Vector2(179, 1358),
        bgOrig: bgOrig,
        bgTopLeft: bgTopLeft,
        bgSize: bgSize,
      );
    add(diary);

    add(
      RectangleComponent(
        size: Vector2(worldSize.x * 0.22, worldSize.x * 0.04),
        position: Vector2(worldSize.x * 0.20, worldSize.y * 0.78),
        paint: Paint()
          ..color = Colors.black.withValues(alpha: 0.18)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
      ),
    );

    final cat = ClickableObject(sprite: catSprite, onTap: onPetTap)
      ..anchor = Anchor.center
      ..size = Vector2(worldSize.x * 0.28, worldSize.x * 0.28)
      ..position = worldToScreen(
        anchorPx: Vector2(433, 1880),
        bgOrig: bgOrig,
        bgTopLeft: bgTopLeft,
        bgSize: bgSize,
      );
    add(cat);
  }
}