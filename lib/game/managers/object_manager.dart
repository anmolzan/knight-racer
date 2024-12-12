import 'dart:math';

import 'package:flame/components.dart';
import '../sprites/boost.dart';
import '/game/sprites/coin_gold.dart';
import '/game/managers/game_manager.dart';
import '/game/car_race.dart';
import '/game/sprites/competitor.dart';

final Random _rand = Random();

class ObjectManager extends Component with HasGameRef<CarRace> {
  ObjectManager();

  double _enemySpawnTimer = 0;
  double _coinSpawnTimer = 0;
  double _boostSpawnTimer = 0;

  @override
  void onMount() {
    super.onMount();

    addEnemy(1);
    _maybeAddEnemy();
    addCoin();
    addBoost();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameRef.gameManager.state != GameState.playing) return;

    _enemySpawnTimer += dt;
    _coinSpawnTimer += dt;
    _boostSpawnTimer += dt;

    if (_enemySpawnTimer > 2) {
      addEnemy(1);
      _maybeAddEnemy();
      _enemySpawnTimer = 0;
    }

    if (_coinSpawnTimer > 6) {
      addCoin();
      _coinSpawnTimer = 0;
    }

    if (_boostSpawnTimer > 15) {

      addBoost();
      _boostSpawnTimer = 0;
    }
  }

  final Map<String, bool> specialPlatforms = {
    'enemy': false,
  };

  void enableSpecialty(String specialty) {
    specialPlatforms[specialty] = true;
  }

  final List<CoinPlatform> _coins = [];

  void addCoin() {
    if (gameRef.gameManager.state != GameState.playing) return;

    var currentX = _rand.nextDouble() * (gameRef.size.x - 50) + 25;
    var currentY =
        gameRef.size.y - (_rand.nextInt(gameRef.size.y.floor()) / 2) - 50;

    var coin = CoinPlatform(
      position: Vector2(currentX, currentY),
    );

    add(coin);
    _coins.add(coin);

    _cleanupCoins();
  }

  final List<BoostPlatform> _boosts = [];

  void addBoost() {
    if (gameRef.gameManager.state != GameState.playing) return;

    var currentX = _rand.nextDouble() * (gameRef.size.x - 50) + 25;
    var currentY =
        gameRef.size.y - (_rand.nextInt(gameRef.size.y.floor()) / 2) - 1000;

    var boost = BoostPlatform(
      position: Vector2(currentX, currentY),
    );

    add(boost);
    _boosts.add(boost);

   // _cleanupBoost();
  }

  final List<EnemyPlatform> _enemies = [];

  void addEnemy(int level) {
    enableSpecialty('enemy');
  }

  void _maybeAddEnemy() {
    if (!specialPlatforms['enemy']!) return;

    var currentX = (gameRef.size.x / 2).toDouble() - 50;
    var currentY =
        gameRef.size.y - (_rand.nextInt(gameRef.size.y.floor()) / 3) - 10;

    var enemy = EnemyPlatform(
      position: Vector2(currentX, currentY),
    );

    add(enemy);
    _enemies.add(enemy);

    _cleanupEnemies();
  }

  Future<void> _cleanupEnemies() async {
    await Future.delayed(const Duration(seconds: 6));
    for (var enemy in _enemies) {
      enemy.removeFromParent();
    }
    _enemies.clear();
  }

  Future<void> _cleanupCoins() async {
    await Future.delayed(const Duration(seconds: 5));
    for (var coin in _coins) {
      coin.removeFromParent();
    }
    _coins.clear();
  }

  // / Future<void> _cleanupBoost() async {
 //    await Future.delayed(const Duration(seconds: 5));
 //    for (var boost in _boosts) {
 //      boost.removeFromParent();
 //    }
 //    _boosts.clear();
 //  }
}
