import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/custom_button.dart';
import '../utils/custom_button_opposite.dart';
import 'animation_car_change.dart';
import 'help_slider_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final bool _isClicked = false;
  bool _isMusicEnabled = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isClickedMusic = false;
  bool _isClickedSound = true;
  String audioPath = 'assets/audio/mu1.mp3';

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void playMusic() async {
    await _audioPlayer.play(AssetSource('audio/mu1.mp3'));
  }

  void pauseMusic() async {
    await _audioPlayer.pause();
    setState(() {
      _isClickedMusic = false;
    });
  }

  void playSound() async {
    await _audioPlayer.play(AssetSource('audio/s_goods.mp3'));
  }

  void pauseSound() async {
    await _audioPlayer.pause();
    setState(() {
      _isClickedSound = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Image(
                image: AssetImage('assets/images/_img/logo.png'),
                height: 120,
                width: 400,
              ),
            ),
            const SizedBox(height: 150),
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Center(
                child: RotationAnimations(),
              ),
            ),
            //  const SizedBox(height: 10),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buttonMoreApps('   More Apps'),
                  const SizedBox(width: 150),
                  buttonHelp('  Help   '),
                ],
              ),
            ),

            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buttonRateUs('  Rate Us'),
                    const SizedBox(width: 30),
                    SizedBox(
                      width: 30,
                      child: buttonMusic('Icons.music_note)'),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                        width: 30,
                        child: buttonSound('Icons.headphones_rounded')),
                    const SizedBox(width: 30),
                    buttonShare('Share'),
                    //
                  ]),
            ),
            const SizedBox(height: 200),
            RichText(
                text: const TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(color: Colors.lightBlueAccent),
            )),
          ],
        ),
      ),
    );
  }

  Widget buttonMoreApps(String buttonName) {
    return GestureDetector(
      //splashColor: Colors.transparent,
      onTap: () {
        if (_isMusicEnabled) {
          playSound();
        }
      },
      child: SizedBox(
        width: 110,
        height: 50,
        child: Center(
          child: Stack(children: [
            SizedBox(
              width: 140,
              height: 30,
              child:
                  CustomPaint(painter: CustomButtonPainter(data: buttonName)),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: ClipOval(

                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(),
                  alignment: Alignment.center,
                  child: const Text(
                    "AD",
                    style: TextStyle(
                      fontFamily: 'Orbitron', // Replace with the actual font
                      fontSize: 8,
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget buttonRateUs(String buttonName) {
    return GestureDetector(
      //splashColor: Colors.transparent,
      onTap: () {
        if (_isMusicEnabled) {
          playSound();
        }
      },
      child: SizedBox(
        width: 110,
        height: 50,
        child: Center(
          child: SizedBox(
            width: 140,
            height: 30,
            child: CustomPaint(painter: CustomButtonPainter(data: buttonName)),
          ),
        ),
      ),
    );
  }

  Widget buttonHelp(String buttonName) {
    return GestureDetector(
      onTap: () {
        if (_isMusicEnabled) {
          playSound();
        }

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HelpSlider(),
            ));
      },
      child: SizedBox(
        width: 90,
        height: 50,
        child: Center(
          child: SizedBox(
            width: 140, // Set the width of the button
            height: 30, // Set the height of the button
            child:
                CustomPaint(painter: CustomButtonPainters(data1: buttonName)),
          ),
        ),
      ),
    );
  }

  Widget buttonMusic(String buttonName) {
    return GestureDetector(
        onTap: () {
          // _isClicked = true;
          if (_isClicked) {
            pauseMusic();
          } else {
            playMusic();
            setState(() {});
          }
        },
        child: Container(
          width: 30,
          height: 30,
          decoration: ShapeDecoration(
              shape: CircleBorder(
                  side: BorderSide(
                      width: 1,
                      color: _isClicked ? Colors.cyanAccent : Colors.grey))),
          child: Icon(
            Icons.music_note,
            color: _isClicked ? Colors.cyanAccent : Colors.grey,
          ),
        ));
  }

  Widget buttonShare(String buttonName) {
    return GestureDetector(
      onTap: () {
        if (_isMusicEnabled) {
          playSound();
        }
      },
      child: SizedBox(
        width: 90,
        height: 50,
        child: Center(
          child: SizedBox(
            width: 140,
            height: 30,
            child:
                CustomPaint(painter: CustomButtonPainters(data1: buttonName)),
          ),
        ),
      ),
    );
  }

  Widget buttonSound(String buttonName) {
    return GestureDetector(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        _isMusicEnabled = !(prefs.getBool('isMusicEnabled') ?? true);
        await prefs.setBool('isMusicEnabled', _isMusicEnabled);
        if (_isMusicEnabled) {
          playSound();
        }

        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: ShapeDecoration(
          shape: CircleBorder(
            side: BorderSide(
                width: 1.2,
                color: _isMusicEnabled ? Colors.cyanAccent : Colors.grey),
          ),
        ),
        child: Icon(
          Icons.headphones_rounded,
          color: _isMusicEnabled ? Colors.cyanAccent : Colors.grey,
        ),
      ),
    );
  }
}
