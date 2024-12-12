import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;


  double _ballPosX = 0.00;

  final double _sensitivity = 10;
  DateTime _lastUpdate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _gyroscopeSubscription = gyroscopeEventStream().listen((GyroscopeEvent event) {
      final now = DateTime.now();
      if (now.difference(_lastUpdate).inMilliseconds > 16) { // Limit to ~60 updates/sec
        setState(() {
          _ballPosX += event.y * _sensitivity;
        });
        _lastUpdate = now;
      }
    });
  }



  @override
  void dispose() {
    // Cancel the subscription to avoid memory leaks
    _gyroscopeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenWidth = MediaQuery.of(context).size.width;
    //final screenHeight = MediaQuery.of(context).size.height;

    // Ensure the ball stays within the screen boundaries
    // final ballPosX =
    //     (_ballPosX).clamp(-screenWidth / 2 + 60, screenWidth / 2 - 60);
    // final ballPosY = (_ballPosY).clamp(-screenHeight / 2 + 25, screenHeight / 2 - 25);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/_img/screen_bg.png'),
                ),
              ),
            ),
          ),
          // Center column for instructions and calibration image
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 300,
                  height: 50,
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Rotate As shown in Image')),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: const ShapeDecoration(
                          shape: CircleBorder(
                            side: BorderSide(color: Colors.black, width: 4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Rotate As shown in Image')));
                  },
                  child: const Image(
                    image: AssetImage('assets/images/_img/calibrate.png'),
                    height: 150,
                    width: 150,
                  ),
                ),
              ],
            ),
          ),
          // Moving Ball
          Positioned(
            left: screenWidth / 2 + _ballPosX - 20,
            // right: screenWidth / 2 + ballPosX +50,
            //top: screenHeight / 2 + ballPosY - 25,
            top: 280,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.cyanAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
