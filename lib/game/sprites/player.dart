import 'dart:async';
import 'package:car_game/game/sprites/coin_goldcar.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:sensors_plus/sensors_plus.dart';
import '/game/car_race.dart';

enum PlayerState {
  left,
  right,
  center,
}

class Player extends SpriteGroupComponent<PlayerState>
    with HasGameRef<CarRace>, KeyboardHandler, CollisionCallbacks {
  Player({
    required this.character,
    this.moveLeftRightSpeed = 200,
  }) : super(
          size: Vector2(60, 90),
          anchor: Anchor.center,
          priority: 1,
        );
  double moveLeftRightSpeed;
  Character character;

  // ignore: unused_field
  int _hAxisInput = 0;
  final int movingLeftInput = -1;
  final int movingRightInput = 1;
  Vector2 velocity = Vector2.zero();

  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    await add(CircleHitbox());
    await _loadCharacterSprites();
    current = PlayerState.center;
    _gyroscopeSubscription = gyroscopeEventStream().asBroadcastStream().listen(
      (event) {
        if (gameRef.gameManager.isPlaying) {
          // gameRef.updateTilt(event.y);
          double tiltSensitivity =
              250; // Adjust this value for tilt sensitivity
          velocity.x = event.y * tiltSensitivity;
          // velocity.x += event.y * 12;
          // _playerTilt = event.y;
          // print('event=> $event');
          // if (event.y < -0.2) {
          //   moveLeft();
          // } else if (event.y > 0.) {
          //   moveRight();
          // }
        }
      },
    );
  }

  @override
  void update(double dt) {
    if (gameRef.gameManager.isIntro || gameRef.gameManager.isGameOver) return;

    // velocity.x = _hAxisInput * moveLeftRightSpeed;

    const double dampingFactor = 1.2;
    velocity.x *= dampingFactor;
    final double marioHorizontalCenter = size.x / 2;

    if (position.x < marioHorizontalCenter + 20) {
      // position.x = gameRef.size.x - (marioHorizontalCenter);
      position.x = marioHorizontalCenter + 20;
    }
    if (position.x > gameRef.size.x - (marioHorizontalCenter + 35)) {
      // position.x = marioHorizontalCenter;
      position.x = gameRef.size.x - (marioHorizontalCenter + 35);
    }

    position += velocity * dt;

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    print('other=> ${other}');
    if (other is CoinPlatform) {
      if (!other.hasCoinEarned) {
        print('other=> TODO update coin value');
        other.updateEarned();
        gameRef.gameManager.increaseCoin();
        other.removeFromParent();
      }
      return;
    }
    gameRef.onLose();
    return;
  }

  // @override
  // bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
  //   _hAxisInput = 0;
  //
  //   if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
  //     moveLeft();
  //   }
  //
  //   if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
  //     moveRight();
  //   }
  //
  //   return true;
  // }

  void moveLeft() {
    _hAxisInput = 0;

    current = PlayerState.left;

    _hAxisInput += movingLeftInput;
  }

  void moveRight() {
    _hAxisInput = 0; // by default not going left or right

    current = PlayerState.right;

    _hAxisInput += movingRightInput;
  }

  void resetDirection() {
    _hAxisInput = 0;
  }

  void reset() {
    velocity = Vector2.zero();
    current = PlayerState.center;
  }

  void resetPosition() {
    position = Vector2(
      (gameRef.size.x - size.x) / 2,
      (gameRef.size.y - 100),
    );
  }

  Future<void> _loadCharacterSprites() async {
    final center = await gameRef.loadSprite('Cars_image/${character.name}.png');

    sprites = <PlayerState, Sprite>{
      PlayerState.center: center,
    };
  }

  @override
  void onRemove() {
    _gyroscopeSubscription?.cancel();
    super.onRemove();
  }
}
