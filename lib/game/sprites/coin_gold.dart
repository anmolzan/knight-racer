import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../car_race.dart';

abstract class GoldCoin<T> extends SpriteGroupComponent<T>
    with HasGameRef<CarRace>, CollisionCallbacks {
  final hitbox = CircleHitbox(
    collisionType: CollisionType.active,
  );

  double direction = 1;
  final Vector2 _velocity = Vector2.zero();
  double speed = 200;

  GoldCoin({
    super.position,
  }) : super(
          size: Vector2.all(40),
          priority: 5,
        );

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    await add(hitbox);

    final points = getRandomPostionOfCoin();

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

  ({double xPoint, double yPoint}) getRandomPostionOfCoin() {
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

enum CoinPlatformState { only }

class CoinPlatform extends GoldCoin<CoinPlatformState> {
  CoinPlatform({super.position});

  bool _hasCoinEarned = false;
  bool get hasCoinEarned => _hasCoinEarned;

  void updateEarned() {
    _hasCoinEarned = true;
  }

  @override
  Future<void>? onLoad() async {
    sprites = <CoinPlatformState, Sprite>{
      CoinPlatformState.only: await gameRef.loadSprite(
        'game/coin.png',
      ),
    };

    current = CoinPlatformState.only;

    return super.onLoad();
  }
}
