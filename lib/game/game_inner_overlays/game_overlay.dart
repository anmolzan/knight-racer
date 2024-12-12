import 'package:flutter/material.dart';
import '/game/car_race.dart';
import 'widgets.dart';

class GameOverlay extends StatefulWidget {
  const GameOverlay(this.game, {super.key});

  final CarRace game;

  @override
  State<GameOverlay> createState() => GameOverlayState();
}

class GameOverlayState extends State<GameOverlay> {
  bool _isPaused = false;

  // bool Visible = false;


  // final Game game = CarRace();
  @override
  void initState() {
    super.initState();
    _loadVisibilityState();
  }

  Future<void> _loadVisibilityState() async {
    setState(() {
      // Visible = prefs.getBool('visible') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Stack(children: [
          Positioned(
          top: 30,
          left: 30,
          child: GameCoinDisplay(game: widget.game),
        ),
        Positioned(
          top: 30,
          right: 30,
          child: ElevatedButton(
            child: _isPaused
                ? const Icon(
              Icons.play_arrow,
              size: 48,
            )
                : const Icon(
              Icons.pause,
              size: 48,
            ),
            onPressed: () {
              (widget.game).togglePauseState();
              setState(
                    () {
                  _isPaused = !_isPaused;
                },
              );
            },
          ),
        ),
        // if (isMobile)
        Positioned(
          bottom: 10,
          child: SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: 100,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: GestureDetector(
                        onTapDown: (details) {
                          (widget.game).player.moveLeft();
                        },
                        onTapUp: (details) {
                          (widget.game).player.resetDirection();
                        },
                        child: const Material(
                          color: Colors.transparent,
                          elevation: 3.0,
                          shadowColor:
                          Colors.cyanAccent,
                          // child: const Icon(Icons.arrow_left, size: 64),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: GestureDetector(
                        onTapDown: (details) {
                          (widget.game).player.moveRight();
                        },
                        onTapUp: (details) {
                          (widget.game).player.resetDirection();
                        },
                        child: const Material(
                          color: Colors.transparent,
                          elevation: 3.0,
                          shadowColor:
                          Colors.cyanAccent,
                          // child: const Icon(Icons.arrow_right, size: 64),
                        ),
                      ),
                    ),
                  ],
                ),
               const SizedBox(height: 50,)
              ],
            ),
          ),
        ),
        if (_isPaused)
    Positioned(
      top: MediaQuery
          .of(context)
          .size
          .height / 2 - 72.0,
      right: MediaQuery
          .of(context)
          .size
          .width / 2 - 72.0,
      child: const Icon(
        Icons.pause_circle,
        size: 144.0,
        color: Colors.black12,
      ),
    )
    ,
    Positioned(
    bottom: 10,
    right: 10,

    child: ValueListenableBuilder(
    valueListenable:widget.game.gameManager.boosterVisibility,
    builder: (context, value, child) {
      return value ? GestureDetector(
        onTap: () {
          widget.game.gameManager.consumeBoost();
          widget.game.backGround.startAcceleration();
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Image(
            image: AssetImage(
              'assets/images/game/boost.png',
            ),
            height: 80,
            width: 80,
          ),
        ),
      )
          : const SizedBox(
        height: 80,
        width: 80,
      );
   // return SizedBox.shrink();
    }
  )

    ),]))
    ;


  }
}
