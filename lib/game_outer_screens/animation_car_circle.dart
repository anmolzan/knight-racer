import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../game/car_race.dart';
import 'level_page_screen.dart';


class RotationCircle extends StatefulWidget {
  const RotationCircle({super.key});

  @override
  State<RotationCircle> createState() => _RotationCircleState();
}

class _RotationCircleState extends State<RotationCircle>
    with SingleTickerProviderStateMixin {
  Character character = Character.rc1;
  late AnimationController _controller;
  final CarouselSliderController buttonCarouselController =
  CarouselSliderController();
  bool isMusicEnabled = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  int currentIndex = 0;

  final List<Character> carList = [
    Character.rc1,
    Character.rc2,
    Character.rc3,
    Character.rc4,
    Character.rc5,
    Character.rc6,
    Character.rc7,
    Character.rc8,
    Character.rc8,
    Character.rc9,
    Character.rc10,
    Character.rc11,
    Character.rc12,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _controller.repeat(); // Continuous rotation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  void playAudio1()async{
    await _audioPlayer.play(AssetSource('audio/s_goods.mp3'));
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 500,
        height: 400,
        child: Stack(
          children: [
            Positioned.fill(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  carSlidingButton('assets/images/_img/popup_pre.png'),

                  carSlidingButton1('assets/images/_img/next_level.png')
                ],
              ),
            ),
            Positioned(
                 left: 20,
              bottom: 0.1,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: button(),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget carSlidingButton(String assetAddress) {
    return GestureDetector(
      onTap: () async{
        if (currentIndex > 0) {
          setState(() {
            currentIndex--;
          });
          buttonCarouselController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,

          );
          final prefs = await SharedPreferences.getInstance();

          isMusicEnabled = (prefs.getBool('isMusicEnabled') ?? true);
          if(isMusicEnabled){
            playAudio1();
          }

        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image(
          image: AssetImage(assetAddress),
          width: 50,
          height: 35,
        ),
      ),
    );
  }


  Widget circle() {
    return RotationTransition(
      turns: _controller,
      child: const Image(
        image: AssetImage('assets/images/_img/round.png'),
        height: 150,
        width: 150,
      ),
    );
  }


  Widget button() {
    return GestureDetector(
      onTap: () async {
        // print('OnTap Called');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LevelPage(
              characters: carList[currentIndex],
            ),
          ),
        );
        if(isMusicEnabled){
          playAudio1();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 180,
          width: 180,
          child: Stack(
            children: [
              Center(child: circle()),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CharacterButton(
                    character: carList[currentIndex],
                    // onTap: () {
                    //   setState(() {
                    //     character = carList[currentIndex];
                    //   });
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => LevelPage(
                    //         characters: carList[currentIndex],
                    //       ),
                    //     ),
                    //   );
                    // },
                    characterWidth: 40,
                  ),
                  CarouselSlider(
                    carouselController: buttonCarouselController,
                    options: CarouselOptions(
                      height: 20,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex = index;
                          character = carList[index];
                        });
                      },
                    ),
                    items: carList.map((item) {
                      return const SizedBox(
                        height: 10,
                        width: 10,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget carSlidingButton1(String assetAddress) {
    return GestureDetector(
      onTap: () {
        if (currentIndex < carList.length - 1) {
          setState(() {
            currentIndex++;
          });
          buttonCarouselController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );
        }
        if(isMusicEnabled){
          playAudio1();
        }
      },
      child: Image(
        image: AssetImage(assetAddress),
        width: 56,
        height: 35,
      ),
    );
  }
}


class CharacterButton extends StatelessWidget {
  const CharacterButton({
    super.key,
    required this.character,
   // required this.onTap,
    required this.characterWidth,
  });

 // final void Function() onTap;
  final Character character;
  final double characterWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/Cars_image/${character.name}.png',
            height: 60,
            width: 60,
          ),
          const SizedBox(height: 4),
          Text(
            character.name,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
