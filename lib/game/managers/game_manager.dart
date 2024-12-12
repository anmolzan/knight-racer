import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '/game/car_race.dart';

class GameManager extends Component with HasGameRef<CarRace> {
  GameManager({required this.character});

  Character character;
  //ValueNotifier<int> score = ValueNotifier(0);
  ValueNotifier<int> coin = ValueNotifier(0);
  GameState state = GameState.intro;

  bool get isPlaying => state == GameState.playing;
  bool get isGameOver => state == GameState.gameOver;
  bool get isIntro => state == GameState.intro;
  void reset() {
    // score.value = 0;
    state = GameState.intro;
  }

  // void increaseScore() {
  //
  //   score.value++;
  //
  // }
  void increaseCoin() {
    ++coin.value;
  }

  void selectCharacter(Character selectedCharcter) {
    character = selectedCharcter;
  }
}

enum GameState { intro, playing, gameOver }
