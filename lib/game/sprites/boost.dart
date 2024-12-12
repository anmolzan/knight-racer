import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:racing_car/game/car_race.dart';

abstract class Booster<T> extends SpriteGroupComponent<T>
    with HasGameRef<CarRace>, CollisionCallbacks {
  final _hittingBox = RectangleHitbox(collisionType: CollisionType.active);

  double direction = 1;
  final Vector2 _velocity = Vector2.zero();
  double speed = 200;

  Booster({
    super.position,
  }) : super(
          size: Vector2.all(40),
          priority: 1,
        );

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    await add(_hittingBox);
    final points = getRandomPositionPoint();
    position = Vector2(points.xPoint, points.yPoint);
  }

  void _move(double dt) {
    _velocity.y = direction * speed;
    position += _velocity * dt;
  }

  @override
  void update(double dt) {
    _move(dt);
    super.update(dt);
  }

  ({double xPoint, double yPoint}) getRandomPositionPoint() {
    final random = Random();
    final randomXPoint =
        50 + random.nextInt((gameRef.size.x.toInt() - 100) - 50);
    final randomYPoint = 50 + random.nextInt(60 - 50);
    return (
      xPoint: randomXPoint.toDouble(),
      yPoint: randomYPoint.toDouble(),
    );
  }
}

enum BoostPlatformState { only }

class BoostPlatform extends Booster<BoostPlatformState> {
  BoostPlatform({super.position});

  @override
  Future<void>? onLoad() async {
    sprites = <BoostPlatformState, Sprite>{
      BoostPlatformState.only: await gameRef.loadSprite(
        'game/boost.png',
      )
    };
    current = BoostPlatformState.only;
    return super.onLoad();
  }
}
