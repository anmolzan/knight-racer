import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '/game/car_race.dart';

class GameManager extends Component with HasGameRef<CarRace> {
  GameManager({required this.character});

  Character character;
  //ValueNotifier<int> score = ValueNotifier(0);
  ValueNotifier<int> coin = ValueNotifier(0);
  GameState state = GameState.intro;

  double _speedMultiplier =1.0;
  double get speedMultiplier =>_speedMultiplier;

  ValueNotifier<bool> boosterVisibility = ValueNotifier(false);
  void boost(){
   if(_speedMultiplier==1.0){
     _speedMultiplier = 2.9;
   }
  }

  bool get isPlaying => state == GameState.playing;
  bool get isGameOver => state == GameState.gameOver;
  bool get isIntro => state == GameState.intro;
  void reset() {
    // score.value = 0;
    state = GameState.intro;
    coin.value=0;
  }

  // void increaseScore() {
  //
  //   score.value++;
  //
  // }
  void increaseCoin() {
    ++coin.value;
  }

  void setBoostAvailable(){
    boosterVisibility.value = true;
  }

  void consumeBoost(){

    boosterVisibility.value = false;
  }

  void selectCharacter(Character selectedCharcter) {
    character = selectedCharcter;
  }
}

enum GameState { intro, playing, gameOver }
