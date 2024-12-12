import 'dart:math';

import 'package:flame/components.dart';
import '/game/sprites/coin_goldcar.dart';
import '/game/managers/game_manager.dart';
import '/game/car_race.dart';
import '/game/sprites/competitor.dart';

final Random _rand = Random();
final Random _rand1 = Random();

class ObjectManager extends Component with HasGameRef<CarRace> {
  ObjectManager();

  @override
  void onMount() {
    super.onMount();

    addEnemy(1);
    _maybeAddEnemy();
    addCoin();
    addGoldCar();
  }

  @override
  void update(double dt) {
    // if (gameRef.gameManager.state == GameState.playing) {
    //   gameRef.gameManager.increaseScore();
    // }
    if (gameRef.gameManager.state == GameState.playing) {
      if (_rand.nextDouble() < 0.01) {
        addCoin();
      }
    }
    addEnemy(1);
    if (gameRef.gameManager.state == GameState.playing) {
      // gameRef.gameManager.increaseCoin();
    }

    super.update(dt);
  }

  final Map<String, bool> specialPlatforms = {
    'enemy': false,
  };

  void enableSpecialty(String specialty) {
    specialPlatforms[specialty] = true;
  }

  void addEnemy(int level) {
    switch (level) {
      case 1:
        enableSpecialty('enemy');
    }
  }

  final List<CoinPlatform> _coins = [];
  var coin = CoinPlatform();
  void addCoin() {
    if (gameRef.gameManager.state != GameState.playing) return;

    // Generate a random position for the coin
    var currentX = _rand1.nextDouble() * (gameRef.size.x - 50) +
        25; // Random X within screen bounds
    var currentY =
        gameRef.size.y - (_rand1.nextInt(gameRef.size.y.floor()) / 2) - 50;

    var coin = CoinPlatform(
      position: Vector2(currentX, currentY),
    );

    add(coin);
    _coins.add(coin);
    // _cleanupCoins();
  }

  void addGoldCar() {}

  final List<EnemyPlatform> _enemies = [];
  void _maybeAddEnemy() {
    if (specialPlatforms['enemy'] != true) {
      return;
    }

    var currentX = (gameRef.size.x.floor() / 2).toDouble() - 50;

    var currentY =
        gameRef.size.y - (_rand.nextInt(gameRef.size.y.floor()) / 3) - 10;
    var enemy = EnemyPlatform(
      position: Vector2(
        currentX,
        currentY,
      ),
    );
    add(enemy);

    _enemies.add(enemy);
    _cleanupEnemies();
  }

  void _cleanupEnemies() {
    Future.delayed(
      const Duration(seconds: 4),
      () {
        _enemies.clear();

        Future.delayed(
          const Duration(seconds: 1),
          () {
            if (gameRef.gameManager.state == GameState.playing) {
              // gameRef.gameManager.increaseCoin();
            }
            _maybeAddEnemy();
          },
        );
      },
    );
  }

  //
  void _cleanupCoins() {
    Future.delayed(
      const Duration(seconds: 15),
      () {
        for (var coin in _coins) {
          coin.removeFromParent();
        }
        _coins.clear();
      },
    );
  }
}
// use of await