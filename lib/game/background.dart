import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';
import '/game/car_race.dart';

class BackGround extends PositionComponent with HasGameRef<CarRace> {
  BackGround({required this.levelIndex});
  late ParallaxComponent parallaxComponent;

  int levelIndex;
  double acceleration = 0.0;
  double maxAcceleration = 2.95; // Maximum acceleration multiplier
  double accelerationDuration = 10.0; // Duration of acceleration
  double elapsedAccelerationTime = 0.0;
  bool isAccelerating = false;

  @override
  Future<void> onLoad() async {
    size = gameRef.size;

    parallaxComponent = await ParallaxComponent.load(
      [
        ParallaxImageData('Roads/road$levelIndex.jpg'),
      ],
      baseVelocity: Vector2(0, -300),
      velocityMultiplierDelta: Vector2(0, 0.8),
      repeat: ImageRepeat.repeatY,
      fill: LayerFill.width,
    );

    add(parallaxComponent);
  }

  void startAcceleration() {
    if (isAccelerating) return;

    isAccelerating = true;
    acceleration = 0.1;
    elapsedAccelerationTime = 0.0;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isAccelerating) {
      elapsedAccelerationTime += dt;

      if (elapsedAccelerationTime <= accelerationDuration) {
        double progress = elapsedAccelerationTime / accelerationDuration;
        double currentAcceleration = 1 + (maxAcceleration - 1) * progress;


        for (final layer in parallaxComponent.parallax!.layers) {
          layer.velocityMultiplier = Vector2(0, currentAcceleration);
        }
      } else {

        for (final layer in parallaxComponent.parallax!.layers) {
          layer.velocityMultiplier = Vector2(0, 1);
        }
        isAccelerating = false;
      }
    }
  }
}
