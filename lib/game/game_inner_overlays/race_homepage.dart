import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../car_race.dart';
import 'game_over_overlay.dart';
import 'game_overlay.dart';
import 'game_start_overlay.dart';

class CarRaceHomePage extends StatelessWidget {
  late final CarRace carRace;
//   const CarRaceHomePage({
//     required this.character,
//     required this.levelIndex,
//     super.key,
//   }):(){
//     carRace =
//         CarRace(character: widget.character, levelIndex: widget.levelIndex);
// }

  final Character character;
  final int levelIndex;

   CarRaceHomePage({super.key,   required this.character, required this.levelIndex,}){
    carRace =CarRace(character: character, levelIndex: levelIndex);
  }
//
//   @override
//   State<CarRaceHomePage> createState() => _CarRaceHomePageState();
// }
//
// class _CarRaceHomePageState extends State<CarRaceHomePage> {

  // @override
  // void initState() {
  //   carRace =
  //       CarRace(character: widget.character, levelIndex: widget.levelIndex);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: GameWidget(

          game: carRace,
          overlayBuilderMap: <String, Widget Function(BuildContext, CarRace)>{
            'gameOverlay': (context, game) => GameOverlay(game),
            'mainMenuOverlay': (context, game) => GameStartOverlay(
                  game,
                  character: character,
                  levelIndex: levelIndex,
                ),
            'gameOverOverlay': (context, game) => GameOverOverlay(game),
          }),
    );
  }
}


