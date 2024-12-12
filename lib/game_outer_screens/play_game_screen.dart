import 'package:flutter/material.dart';
import 'package:racing_car/game_outer_screens/setting_screen.dart';
import '../game/game_inner_overlays/race_homepage.dart';
import '/game/car_race.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PlayGame extends StatefulWidget {
  const PlayGame({
    required this.characters,
    super.key,
    required this.levelIndex,
  });

  final Character characters;

  final int levelIndex;

  @override
  State<PlayGame> createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame> {
  // int tCoin = 0;
  late int totalCoin = 0;
  bool isMusicEnabled=false;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(top: 140),
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/images/_img/screen_bg.png',
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CarRaceHomePage(
                              character: widget.characters,
                              levelIndex: widget.levelIndex,
                            )));
                loadData();
              },
              style: const ButtonStyle(
                  side: WidgetStatePropertyAll(
                      BorderSide(color: Colors.cyanAccent, width: 2)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(60, 100),
                          bottomRight: Radius.elliptical(20, 90),
                          bottomLeft: Radius.zero,
                          topRight: Radius.zero)))),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'PLAY',
                  style: TextStyle(color: Colors.cyanAccent),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context)=>const Setting(),));
                },
                style: const ButtonStyle(
                    side: WidgetStatePropertyAll(
                        BorderSide(color: Colors.cyanAccent, width: 2)),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(60, 100),
                            bottomRight: Radius.elliptical(20, 90),
                            bottomLeft: Radius.zero,
                            topRight: Radius.zero)))),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 5),
                  child: Text(
                    'SETTING',
                    style: TextStyle(color: Colors.cyanAccent),
                  ),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context,totalCoin);
                },
                style: const ButtonStyle(
                    side: WidgetStatePropertyAll(
                        BorderSide(color: Colors.cyanAccent, width: 2)),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(60, 100),
                            bottomRight: Radius.elliptical(20, 90),
                            bottomLeft: Radius.zero,
                            topRight: Radius.zero)))),
                child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('BACK',
                        style: TextStyle(
                          color: Colors.cyanAccent,
                          fontStyle: FontStyle.italic,
                        )))),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/game/best_score.png',
              width: 500,
              fit: BoxFit.fitWidth,
            ),
            Container(
              width: 500,
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(
                    'assets/images/game/score_bg.png',
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  'Total Coin: $totalCoin',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
     totalCoin = prefs.getInt('totalCoin') ?? 0;

    if (mounted) setState(() {});
    // totalCoin = tCoin + totalCoin;
  }
}
