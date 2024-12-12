import 'package:flutter/material.dart';
import '/game/car_race.dart';

class GameStartOverlay extends StatefulWidget {
  const GameStartOverlay(this.game,
      {super.key, required this.character, required this.levelIndex});

  final CarRace game;
  final int levelIndex;
  final Character character;

  @override
  State<GameStartOverlay> createState() => _GameStartOverlayState();
}

class _GameStartOverlayState extends State<GameStartOverlay> {
  // final Game game = CarRace();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            bottom: 100,
            left: 20,
            child: InkWell(
                onTap: () {
                  // widget.game.gameManager.selectCharacter(widget.character);
                  widget.game.startGame();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Click Here to Start ',
                        style:
                            TextStyle(fontSize: 35, color: Colors.cyanAccent),
                      ),
                      SizedBox(
                        height: 20,
                        width: 10,
                      ),
                      Text(
                        'race ',
                        style:
                            TextStyle(fontSize: 35, color: Colors.cyanAccent),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
