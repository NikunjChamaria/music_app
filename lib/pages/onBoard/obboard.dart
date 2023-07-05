import 'package:flutter/material.dart';
import 'package:music_app/constants/colors.dart';
import 'package:music_app/pages/onBoard/page1.dart';
import 'package:music_app/pages/onBoard/page2.dart';
import 'package:music_app/pages/onBoard/page3.dart';
import 'package:music_app/pages/onBoard/page4.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  PageController? pageController;
  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "dot",
      child: Stack(
        children: [
          PageView(
            physics: const BouncingScrollPhysics(),
            controller: pageController,
            children: const [PageOne(), PageTwo(), PageThree(), PageFour()],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SmoothPageIndicator(
                controller: pageController!, // PageController
                count: 4,

                effect: SlideEffect(
                    spacing: 8.0,
                    type: SlideType.slideUnder,
                    radius: 4.0,
                    dotWidth: 24.0,
                    dotHeight: 16.0,
                    paintStyle: PaintingStyle.fill,
                    strokeWidth: 1.5,
                    dotColor: Colors.grey,
                    activeDotColor: yellow), // your preferred effect
              ),
            ),
          )
        ],
      ),
    );
  }
}
