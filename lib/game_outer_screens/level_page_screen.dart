import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:racing_car/game_outer_screens/play_game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../game/car_race.dart';

class LevelPage extends StatefulWidget {
  const LevelPage({super.key, required this.characters});

  final Character characters;

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  List<int> unlockedLevels = [];
  bool isMusicEnabled=false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
    _loadUnlockedLevels();
  }

  void _loadUnlockedLevels() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> levels = prefs.getStringList('unlockedLevels') ?? [];
    setState(() {
      unlockedLevels = levels.map(int.parse).toList();
    });
  }
  void playAudio1()async{
    await _audioPlayer.play(AssetSource('audio/s_goods.mp3'));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Container(
            width: double.infinity,
            height: double.infinity,
            //padding: const EdgeInsets.only(top: 140),
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/_img/screen_bg.png',
                ),
              ),
            ),

           // top: 20,
            child:GridView.count(
              crossAxisCount: 2,
               mainAxisSpacing: 10,
               crossAxisSpacing: 10,
               primary: false,
               scrollDirection: Axis.vertical,
               children: [
                 levelsButtonOpen(context,
                     'assets/images/images_level/level_screen1.png', 1),
                 levelsButton(
                     context,
                     'assets/images/images_level/level_1_press_1.png',
                     'assets/images/images_level/level_screen2.png',
                     2,
                     2000),
                 levelsButton(
                     context,
                     'assets/images/images_level/level_1_press_1.png',
                     'assets/images/images_level/level_screen3.png',
                     3,
                     3000),
                 levelsButton(
                     context,
                     'assets/images/images_level/level_1_press_1.png',
                     'assets/images/images_level/level_screen4.png',
                     4,
                     4000),
                 levelsButton(
                     context,
                     'assets/images/images_level/level_1_press_1.png',
                     'assets/images/images_level/level_screen5.png',
                     5,
                     5000),
                 levelsButton(
                     context,
                     'assets/images/images_level/level_1_press_1.png',
                     'assets/images/images_level/level_screen6.png',
                     6,
                     6000),
                 levelsButton(
                     context,
                     'assets/images/images_level/level_1_press_1.png',
                     'assets/images/images_level/level_screen7.png',
                     7,
                     7000),
                 levelsButton(
                     context,
                     'assets/images/images_level/level_1_press_1.png',
                     'assets/images/images_level/level_screen8.png',
                     8,
                     8000),
                 levelsButton(
                     context,
                     'assets/images/images_level/level_1_press_1.png',
                     'assets/images/images_level/level_screen9.png',
                     9,
                     9000),
                 levelsButton(
                     context,
                     'assets/images/images_level/level_1_press_1.png',
                     'assets/images/images_level/level_screen10.png',
                     10,
                     10000),
                 levelsButton(
                     context,
                     'assets/images/images_level/level_1_press_1.png',
                     'assets/images/images_level/level_screen11.png',
                     11,
                     11000),
                 levelsButton(
                     context,
                     'assets/images/images_level/level_1_press_1.png',
                     'assets/images/images_level/level_screen12.png',
                     12,
                     12000),


              ]),
            ),
          );

  }

  Widget levelsButtonOpen(
      BuildContext context, String assetAddress, int levelIndex) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PlayGame(
                  characters: widget.characters,
                  levelIndex: levelIndex,
                ),
          ),
        );
        final prefs = await SharedPreferences.getInstance();

        isMusicEnabled = (prefs.getBool('isMusicEnabled') ?? true);
        if (isMusicEnabled) {
          playAudio1();
        }
      },

      child: Image(
        image: AssetImage(assetAddress),
        fit: BoxFit.contain,
        width: MediaQuery.of(context).size.width*0.45,
        height: MediaQuery.of(context).size.width*0.45,
      ),
    );
    }

  Widget levelsButton(
      BuildContext context,
      String assetAddress,
      String levelAddress,
      int levelIndex,
      int reqCoin,
      ) {
    bool isUnlocked = unlockedLevels.contains(levelIndex);

    return GestureDetector(
      onTap: isUnlocked
          ? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayGame(
              characters: widget.characters,
              levelIndex: levelIndex,
            ),
          ),
        );

      }
          : () async {
        final prefs = await SharedPreferences.getInstance();
        int totalCoin = prefs.getInt('totalCoin') ?? 0;

        if (reqCoin < totalCoin) {
          showDialog(
            context: context,
            builder: (context) => LevelDialog(
              reqCoin: reqCoin,
              totCoin: totalCoin,
              characters: widget.characters,
              levelIndex: levelIndex,
            ),
          ).then((_) => _loadUnlockedLevels());
        } else {
          showDialog(
            context: context,
            builder: (context) => LevelDialog1(
              character: widget.characters,
              reqCoin: reqCoin,
              totCoin: totalCoin,
              levelIndex: levelIndex,
            ),
          );
        }
        if(isMusicEnabled){
          playAudio1();
        }
      },
      child: Container(decoration: BoxDecoration(image: DecorationImage(
        image: AssetImage(levelAddress),
        fit: BoxFit.contain,

      )),
              child: isUnlocked ?null: Image(
                image: AssetImage(assetAddress),
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width*0.45,
                height: MediaQuery.of(context).size.width*0.45,
              ),


      ),
    );
  }
}

class LevelDialog extends StatelessWidget {
   LevelDialog(
      {super.key,
      required this.reqCoin,
      required this.totCoin,
      required this.characters,
      required this.levelIndex});

  final int reqCoin;
  final int totCoin;

  final Character characters;

  final int levelIndex;
   final AudioPlayer _audioPlayer = AudioPlayer();
  void playAudio1()async{
    await _audioPlayer.play(AssetSource('audio/s_goods.mp3'));
  }
 final bool isMusicEnabled=false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.cyan, width: 5),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                topLeft: Radius.zero,
                bottomRight: Radius.zero)),
        backgroundColor: Colors.black54,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            //color: Colors.black54,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.zero,
                    bottomRight: Radius.zero),
                border: Border(
                    top: BorderSide(
                      color: Colors.cyan,
                      width: 1,
                    ),
                    right: BorderSide(
                      color: Colors.cyan,
                      width: 1,
                    ),
                    left: BorderSide(
                      color: Colors.cyan,
                      width: 1,
                    ),
                    bottom: BorderSide(
                      color: Colors.cyan,
                      width: 1,
                    ))),
            height: 115,
            width: 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Unlock Cost: " $reqCoin " Coins',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.cyanAccent,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                Text(
                  'You Have:"$totCoin" Coins',
                  style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontStyle: FontStyle.italic,
                      fontSize: 16),
                ),
                Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();


                          int totalCoin = prefs.getInt('totalCoin') ?? 0;


                          int remainCoin = totalCoin - reqCoin;


                          await prefs.setInt('totalCoin', remainCoin);

                          List<String> unlockedLevels =
                              prefs.getStringList('unlockedLevels') ?? [];


                          if (!unlockedLevels.contains(levelIndex.toString())) {
                            unlockedLevels.add(levelIndex.toString());
                            await prefs.setStringList('unlockedLevels', unlockedLevels);
                          }

                          if (context.mounted) {
                            Navigator.pop(context);
                           // Navigator.pop(context);
                          }

                          if(isMusicEnabled){
                            playAudio1();
                          }

                        },
                        style: const ButtonStyle(
                            side: WidgetStatePropertyAll(
                                BorderSide(color: Colors.cyanAccent, width: 2)),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.elliptical(60, 100),
                                        bottomRight: Radius.elliptical(20, 90),
                                        bottomLeft: Radius.zero,
                                        topRight: Radius.zero)))),
                        child: const Text(
                          'Buy',
                          style: TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 10,
                          ),
                        )),
                    const SizedBox(
                      width: 80,
                    ),
                    SizedBox(
                      width: 60,
                      child: ElevatedButton(
                          onPressed: () { Navigator.pop(context);if(isMusicEnabled){
                            playAudio1();
                          }},
                          style: const ButtonStyle(
                              side: WidgetStatePropertyAll(BorderSide(
                                  color: Colors.cyanAccent, width: 2)),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.elliptical(60, 100),
                                          bottomRight:
                                              Radius.elliptical(20, 90),
                                          bottomLeft: Radius.zero,
                                          topRight: Radius.zero)))),
                          child: const Text(
                            'Ok',
                            style: TextStyle(
                                color: Colors.cyanAccent,
                                fontSize: 9,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LevelDialog1 extends StatelessWidget {
  const LevelDialog1(
      {super.key,
      required this.character,
      required this.reqCoin,
      required this.totCoin,
      required this.levelIndex});

  final Character character;

  final int reqCoin;

  final int totCoin;

  final int levelIndex;

  @override
  Widget build(BuildContext context) {
    int neededCoin = reqCoin - totCoin;
    return Center(
      child: Dialog(
        shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.cyan, width: 5),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                topLeft: Radius.zero,
                bottomRight: Radius.zero)),
        backgroundColor: Colors.black54,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            //color: Colors.black54,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.zero,
                    bottomRight: Radius.zero),
                border: Border(
                    top: BorderSide(
                      color: Colors.cyan,
                      width: 1,
                    ),
                    right: BorderSide(
                      color: Colors.cyan,
                      width: 1,
                    ),
                    left: BorderSide(
                      color: Colors.cyan,
                      width: 1,
                    ),
                    bottom: BorderSide(
                      color: Colors.cyan,
                      width: 1,
                    ))),
            height: 115,
            width: 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    //'Unlock Cost: " $reqCoin " Coins',
                    'You Do Not Have Sufficient Coins',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.cyanAccent,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                Text(
                  // 'You Have:"$totCoin" Coins',
                  'You Need : $neededCoin More coins',
                  style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontStyle: FontStyle.italic,
                      fontSize: 16),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) =>
                      //           LevelPage(characters: character),
                      //     ));
                      Navigator.pop(context, neededCoin);
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
                    child: const Text(
                      'Play Game',
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 10,
                      ),
                    )),
                const SizedBox(
                  width: 80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
// Future<void> loadData() async {
//   final prefs = await SharedPreferences.getInstance();
//   totalCoin = prefs.getInt('totalCoin') ?? 0;
//   if (mounted) ;
//   // totalCoin = tCoin + totCoin;
// }
}
