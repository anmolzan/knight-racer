import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '/game/car_race.dart';
import 'widgets.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay(this.game, {super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF195CB5),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Text(
            'Game Over',
            style: Theme
                .of(context)
                .textTheme
                .displayMedium!
                .copyWith(),
          ),
          const SizedBox(height: 50),
          Image.asset('assets/images/game/coin.png'),

          Padding(
            padding: const EdgeInsets.only(left: 38.0),
            child: GameCoinDisplay(
              game: game,
              isLight: true,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              (game as CarRace).resetGame();
            },
            style: ButtonStyle(
              minimumSize: WidgetStateProperty.all(
                const Size(200, 75),
              ),

            ),
            child: const Text('Play Again', style: TextStyle(fontSize: 25),),

          )],
          ),
        ),
      ),
    );
  }
}
