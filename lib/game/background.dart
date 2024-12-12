import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';
import '/game/car_race.dart';

class BackGround extends PositionComponent with HasGameRef<CarRace> {
  BackGround({required this.levelIndex});
  late ParallaxComponent parallaxComponent;

  int levelIndex; // Declare the sprite

  @override
  Future<void> onLoad() async {
    // Load your sprite here
    // final sprite = await Sprite.load(
    //     'Roads/road${levelIndex}.jpg'); // Load the background image
    size = gameRef.size;
    parallaxComponent = await ParallaxComponent.load([
      ParallaxImageData('Roads/road$levelIndex.jpg'), // Far background layer
      //ParallaxImageData('game/layer1.png'),
      // ParallaxImageData('game/layer_6.png', ),
      //ParallaxImageData('game/layer_4.webp'),// Middle layer
      // ParallaxImageData('background/layer2.png'),  // Foreground layer
    ],
        baseVelocity: Vector2(0, -200), // Speed of vertical scrolling
        velocityMultiplierDelta: Vector2(0, 0.8),
        repeat: ImageRepeat.repeatY,
        fill: LayerFill.width); // Set the size based on your sprite

    // Add the parallax component to the game
    add(parallaxComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Any additional logic for the background can be implemented here
  }
}
