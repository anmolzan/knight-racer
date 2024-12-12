import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '/game/car_race.dart';

//
class GameCoinDisplay extends StatelessWidget {
  const GameCoinDisplay({super.key, required this.game, this.isLight = false});

  final Game game;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: (game as CarRace).gameManager.coin,
      builder: (context, value, child) {
        // totalCoin=value;
        // saveData(totalCoin);
        return SizedBox(
          width: 250,
          height: 50,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/game/coin.png',
                height: 30,
                width: 30,
              ),
              Text('Coin: $value',
                  style: Theme.of(context).textTheme.displaySmall!),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.pop(context, value);
              //   },
              //   child: const Text('Exit'),
              // )
            ],
          ),
        );
      },
    );
  }

  // Future<void> saveData(int totalCoin) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt('totalCoin', totalCoin);
  // }
}
