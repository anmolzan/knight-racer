import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '/game/car_race.dart';

abstract class Competitor<T> extends SpriteGroupComponent<T>
    with HasGameRef<CarRace>, CollisionCallbacks {
  final hitBox = RectangleHitbox();

  double direction = 1;
  final Vector2 _velocity = Vector2.zero();
  double speed = 200*2.25;

  Competitor({super.position}) : super(size: Vector2(60,100), priority: 1);

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    await add(hitBox);

    final points = getRandomPositionOfEnemy();

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

  ({double xPoint, double yPoint}) getRandomPositionOfEnemy() {
    final random = Random();
    final randomXPoint =
        50 + random.nextInt((gameRef.size.x.toInt() - 100) - 50);

    final randomYPoint = random.nextInt(60 - 50);

    return (
      xPoint: randomXPoint.toDouble(),
      yPoint: randomYPoint.toDouble(),
    );
  }
}

enum EnemyPlatformState { only }

class EnemyPlatform extends Competitor<EnemyPlatformState> {
  EnemyPlatform({super.position});

  final List<String> enemy = [
    'run_op1',
    'run_op2',
    'run_op3',
    'run_op4',
  ];

  @override
  Future<void>? onLoad() async {
    int enemyIndex = Random().nextInt(enemy.length);

    String enemySprite = enemy[enemyIndex];

    sprites = <EnemyPlatformState, Sprite>{
      EnemyPlatformState.only:
          await gameRef.loadSprite('game/$enemySprite.png'),
    };

    current = EnemyPlatformState.only;

    return super.onLoad();
  }
}
