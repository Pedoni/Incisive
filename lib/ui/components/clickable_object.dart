import 'dart:ui';

import 'package:flame/events.dart';
import 'package:flame/components.dart';

class ClickableObject extends SpriteComponent with TapCallbacks {
  ClickableObject({required super.sprite, required this.onTap});

  final VoidCallback onTap;

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }
}
