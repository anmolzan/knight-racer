import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HelpSlider extends StatefulWidget {
  const HelpSlider({super.key});

  @override
  State<HelpSlider> createState() => _HelpSliderState();
}

class _HelpSliderState extends State<HelpSlider> {
  final List<AssetImage> imgList=[
    const AssetImage('assets/images/hdx/help1.png'),
    const AssetImage('assets/images/hdx/help2.png'),
    const AssetImage('assets/images/hdx/help3.png'),
    const AssetImage('assets/images/hdx/help4.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black54,body: Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CarouselSlider(
            options: CarouselOptions(
              height: 600, viewportFraction: 1.0, enlargeCenterPage: false,),
            items: List.of(imgList.map((item)=>Image(image: item)),
            ).toList(),
        ),
      );

    }),

    );
  }
  }
