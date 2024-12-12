import 'dart:async';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/game/sprites/coin_gold.dart';
import '/game/background.dart';
import '/game/managers/game_manager.dart';
import '/game/managers/object_manager.dart';
import '/game/sprites/competitor.dart';
import '/game/sprites/player.dart';

enum Character { rc1, rc2, rc3, rc4, rc5, rc6, rc7, rc8, rc9, rc10, rc11, rc12 }

class CarRace extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  final Character character;
  int levelIndex;
  CarRace({super.children, required this.character, required this.levelIndex});

  late final BackGround backGround;
  late final GameManager gameManager;
  ObjectManager objectManager = ObjectManager();
  int screenBufferSpace = 200;

  EnemyPlatform platFrom = EnemyPlatform();
  CoinPlatform platform1 = CoinPlatform();
  late Player player;
  late AudioPool pool;
  bool isMusicEnabled = true;

  double timeSinceLastUpdate = 0.0;
  late final double updateInterval; // Initialized later in onLoad()

  // Sensor subscriptions

  // double _playerTilt = 0.0; // Tilt value from gyroscope
  // // Proximity sensor state
  //
  // updateTilt(double y) {
  //   _playerTilt += y;
  // }

  @override
  FutureOr<void> onLoad() async {
    // gameManager.selectCharacter(character);
    backGround = BackGround(levelIndex: levelIndex, );
    gameManager = GameManager(character: character);
    // print('command reaching');
    await add(backGround);
    await add(gameManager);
    overlays.add('gameOverlay');
    final prefs = await SharedPreferences.getInstance();
    isMusicEnabled = prefs.getBool('isMusicEnabled') ?? true;
    pool = await FlameAudio.createPool(
      'bgm.mp3',
      minPlayers: 3,
      maxPlayers: 4,

    );


    const double desiredFps = 90.0;
    updateInterval = 1.0 / desiredFps;
  }

  @override
  void update(double dt,) {

    timeSinceLastUpdate += dt;

    // Run the update logic only when enough time has passed
    // if (timeSinceLastUpdate >= updateInterval)
    // {
    timeSinceLastUpdate = 0.0; // Reset time accumulator

    // Call the regular update logic
    super.update(dt);

    if (gameManager.isGameOver) {
      return;
    }

    if (gameManager.isIntro) {
      overlays.add('mainMenuOverlay');
      return;
    }

    if (gameManager.isPlaying) {
      // // Use the gyroscope to control player movement
      // if (_playerTilt.abs() > 0.05) {
      //   // Sensitivity threshold for tilt
      //   player.velocity.x = _playerTilt *
      //       player.moveLeftRightSpeed; // Control movement with gyroscope
      // }

      // Calculate the bounds for the camera
      const left = 0.0;
      final top = camera.viewfinder.position.y - screenBufferSpace; // Top bound
      final width = camera.viewfinder.visibleWorldRect.width;
      final height =
          camera.viewfinder.position.y + backGround.size.y; // Bottom bound

      // Set the camera bounds using the calculated rectangle
      camera.setBounds(Rectangle.fromLTRB(
        left,
        top,
        left + width, // right = left + width
        top + height, // bottom = top + height
      ));
    }
    // }
  }

  @override
  Color backgroundColor() {
    return  Colors.black;
  }
  BackGround backSide(){
    return backGround;
  }
  void setCharacter() {
    player = Player(
      character: gameManager.character,
      moveLeftRightSpeed: 200,
    );
    add(player);
  }

  void initializeGameStart() {
    setCharacter();
    gameManager.reset();

    if (children.contains(objectManager)) {
      objectManager.removeFromParent();
    }

    // Set bounds for the camera using Rect.fromLTRB
    const left = 0.0;
    final top =
        -backGround.size.y; // Top of screen is 0, so negative is off-screen
    final width = camera.viewfinder.visibleWorldRect.width;
    final height =
        backGround.size.y + screenBufferSpace; // Bottom bound off the screen

    final rect = Rectangle.fromLTRB(
      left,
      top,
      left + width, // right = left + width
      top + height, // bottom = top + height
    );

    // Set the camera bounds
    camera.setBounds(rect);

    camera.follow(player); // Follow the player
    player.resetPosition();

    objectManager = ObjectManager();
    add(objectManager);
    if(isMusicEnabled){
    // pauseAudio();
    startBgmMusic();
    }
    else{

    }
  }

  void startBgmMusic() async{
    FlameAudio.bgm.initialize();
   await FlameAudio.bgm.play('bgm.mp3', volume: 1);
  }
  void pauseAudio() {
    FlameAudio.bgm.stop();
  }
  void onLose() async {
    gameManager.state = GameState.gameOver;
    player.removeFromParent();
    FlameAudio.bgm.stop();
    int coin = gameManager.coin.value;
    final prefs = await SharedPreferences.getInstance();
    int availableCoin = prefs.getInt('totalCoin') ?? 0;
    await prefs.setInt("totalCoin", availableCoin + coin);
    //totalCoin
    // gameManager.coin.value=0;
    overlays.add('gameOverOverlay');
  }

  void togglePauseState() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }

  void resetGame() {
    startGame();
    overlays.remove('gameOverOverlay');
  }

  void startGame() {
    initializeGameStart();
    gameManager.state = GameState.playing;
    overlays.remove('mainMenuOverlay');
  }

  @override
  void onRemove() {
    // Cancel the gyroscope and proximity subscriptions when the game is removed

    super.onRemove();
  }
}
