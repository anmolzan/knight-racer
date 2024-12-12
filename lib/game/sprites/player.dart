import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:racing_car/game/sprites/boost.dart';
import 'package:racing_car/game/sprites/competitor.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '/game/car_race.dart';
import 'coin_gold.dart';

enum PlayerState {
  left,
  right,
  center,
}
final Map<String,Vector2>characterSizes={
  'rc1': Vector2(60,105),
  'rc2': Vector2(60,95),
  'rc3': Vector2(60,100),
  'rc4': Vector2(60,100),
  'rc5': Vector2(60,115),
  'rc6': Vector2(60,110),
  'rc7': Vector2(60,90),
  'rc8': Vector2(60,110),
  'rc9': Vector2(60,105),
  'rc10': Vector2(60,105),
  'rc11': Vector2(60,105),
  'rc12': Vector2(60,105),

};


class Player extends SpriteGroupComponent<PlayerState>
    with HasGameRef<CarRace>, KeyboardHandler, CollisionCallbacks {
  Player({
    required this.character,
    this.moveLeftRightSpeed = 200,
    this.mass = 1.0,
    this.gravity = 9.8,
  }) : super(
          size: characterSizes[character.name]??Vector2(60, 110),
          anchor: Anchor.center,
          priority: 1,
         // angle: 10
        );
  double moveLeftRightSpeed;
  Character character;
  double mass;
  double gravity;
  bool hasMoveEffect = false;
   bool visible =false;

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
          double tiltSensitivityX =
              90;
         // double tiltSensitivityY=100;
          velocity.x = event.y * tiltSensitivityX;
          //velocity.y = event.x * tiltSensitivityY;
          // velocity.x += event.y * 12;
          // _playerTilt = event.y;
          // print('event=> $event');
          // if (event.y < -0.2) {
          //   moveLeft();
          // } else if (event.y > 0.) {
          //   moveRight();
          // }
          const double maxTiltAngle = 0.24 ; // Maximum rotation angle in radians
          angle = (event.y * maxTiltAngle).clamp(-maxTiltAngle, maxTiltAngle);
        }
      },
    );
  }

  @override
  void update(double dt) {
    if (gameRef.gameManager.isIntro || gameRef.gameManager.isGameOver) return;

    // velocity.x = _hAxisInput * moveLeftRightSpeed;

    const double dampingFactor = 1.1;
    velocity.x *= dampingFactor;
    final double marioHorizontalCenter = size.x / 2;

    if (position.x < marioHorizontalCenter + 35) {
      // position.x = gameRef.size.x - (marioHorizontalCenter);
      position.x = marioHorizontalCenter + 35;
    }
    if (position.x > gameRef.size.x - (marioHorizontalCenter + 35)) {
      // position.x = marioHorizontalCenter;
      position.x = gameRef.size.x - (marioHorizontalCenter + 35);
    }
    // if (position.y < marioHorizontalCenter + 25) {
    //   // position.x = gameRef.size.x - (marioHorizontalCenter);
    //   position.y = marioHorizontalCenter + 25;
    // }
    // if (position.y > gameRef.size.y - (marioHorizontalCenter + 35)) {
    //   // position.x = marioHorizontalCenter;
    //   position.y = gameRef.size.y - (marioHorizontalCenter + 35);
    // }

    position += velocity * dt;

    super.update(dt);
  }

  @override
  Future<void> onCollision(Set<Vector2> intersectionPoints, PositionComponent other) async {
    super.onCollision(intersectionPoints, other);

    if (other is CoinPlatform) {
      if (!other.hasCoinEarned) {
        other.updateEarned();
        gameRef.gameManager.increaseCoin();

        final Vector2 topLeftCorner = Vector2(20, -150);

        // Add MoveEffect to the coin
        other.add(
          MoveEffect.to(
            topLeftCorner, // Move to top-left corner
            EffectController(
              duration: 1.0,
              curve: Curves.easeInSine, // Smooth easing
            ),
            onComplete: () {
              other.removeFromParent(); // Remove the coin after animation
            },
          ),
        );
      }
      return;
    }

    if(other is BoostPlatform){
      gameRef.gameManager.setBoostAvailable();
      other.removeFromParent(); // Remove the coin after animation

      // gameRef.backGround.startAcceleration();
    // final pref= await SharedPreferences.getInstance();
    // visible=(pref.getBool('visible')??false);
    // await pref.setBool('visible', visible);
      return;
    }

  // if (!hasMoveEffect) {
    //   hasMoveEffect = true;
    //   add(
    //     MoveEffect.to(
    //       Vector2(position.x + 50, position.y),
    //       EffectController(duration: 0.5),
    //       onComplete: () {
    //         hasMoveEffect = false;
    //       },
    //     ),
    //   );
    // }


    if (other is EnemyPlatform) {
      gameRef.onLose();
    }
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

    current = PlayerState.left;

  }

  void moveRight() {
// by default not going left or right

    current = PlayerState.right;

  }

  void resetDirection() {
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
   // final fire =await gameRef.loadSprite('game/cloud.png');

    sprites = <PlayerState, Sprite>{
      PlayerState.center: center,
    };
    final fireAnimation = SpriteAnimationComponent.fromFrameData(
      await gameRef.images.load('game/cloud1.png'),
      SpriteAnimationData.sequenced(
        amount: 10,
        textureSize: Vector2(32, 32),
        stepTime: 0.01,
      ),
      position: Vector2(size.x / 2, size.y + 25),
      size: Vector2(30, 50),
      anchor: Anchor.center,
    );
    await add(fireAnimation);
  }

  @override
  void onRemove() {
    _gyroscopeSubscription?.cancel();
    super.onRemove();
  }
}
