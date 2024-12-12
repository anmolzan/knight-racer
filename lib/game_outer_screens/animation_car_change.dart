import 'package:flutter/material.dart';

import 'cars_dialog.dart';

class RotationAnimations extends StatefulWidget {
  const RotationAnimations({super.key});

  @override
  State<RotationAnimations> createState() => _RotationAnimationsState();
}

class _RotationAnimationsState extends State<RotationAnimations>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {}
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rotating background image
          animationButton(),
          button(),
        ],
      ),
    );
  }

  Widget animationButton() {
    return RotationTransition(
      turns: _controller,
      child: Image.asset(
        'assets/images/_img/car_selection_circle.png',
        width: 150, // Size of the rotating background image
        height: 150,
      ),
    );
  }

  Widget button() {
    return IconButton(
      onPressed: () async {
        if (!_controller.isAnimating) {
          _controller.forward();
          await openAlert();
          if (mounted) {
            _controller.forward();
          }
        } else {
          // _controller.stop();

          // await showDialog(
          //   context: context,
          //   builder: (BuildContext context) => const Cars(),
          // );
        }
      },
      icon: const Image(
        image: AssetImage('assets/images/_img/car_selection_bg.png'),
        width: 100, // Size of the icon button
        height: 100,
      ),
    );
  }

  Future openAlert() async {
    await Future.delayed(const Duration(seconds: 2));
    await showDialog(
      context: context,
      builder: (BuildContext context) => const Cars(),
    );
  }
}
