import 'package:flutter/material.dart';

import 'animation_car_circle.dart';

class Cars extends StatelessWidget {
  const Cars({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Dialog(shape: const RoundedRectangleBorder(side: BorderSide(color:  Colors.cyan,width: 5),
              borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomLeft: Radius.circular(20),
                  topLeft: Radius.zero,bottomRight: Radius.zero)),backgroundColor: Colors.black54,elevation: 5,
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
        height: 185,
        width: 140,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 250,height: 400,
               child: RotationCircle(),
             )],
        ),
      ),
    ),
          ),
        );
  }
}
