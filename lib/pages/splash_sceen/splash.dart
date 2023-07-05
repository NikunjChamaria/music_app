import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/constants/colors.dart';
import 'package:music_app/pages/home/home.dart';
import 'package:music_app/pages/onBoard/obboard.dart';
import 'package:music_app/widgets/textstyle.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<double> _sizeAnimation;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: const Offset(0.0, -0.2),
    )
        .chain(
          CurveTween(curve: Curves.bounceOut),
        )
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.9, curve: Curves.easeInOut),
          ),
        );
    _sizeAnimation = Tween<double>(
      begin: 13.0,
      end: 344,
    ).chain(CurveTween(curve: Curves.bounceInOut)).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.9, 1, curve: Curves.easeInOut),
          ),
        );

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        audioPlayer.play(AssetSource("sound.mp3"), volume: 2);
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.getString("email") == null
            ? Get.to(() => const OnBoard(),
                fullscreenDialog: true,
                transition: Transition.zoom,
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeInOutCirc)
            : Get.to(() => const HomePage(),
                fullscreenDialog: true,
                transition: Transition.zoom,
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeInOutCirc);
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Stack(children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            "Only Music",
            style: roboto(white, 60, FontWeight.w800),
          ),
        ),
        Positioned(
          right: 80,
          top: 410,
          child: Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: black,
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Positioned(
              top: MediaQuery.of(context).size.height *
                  (0.629 + _animation.value.dy * 0.8),

              right: 80, // Adjust the height for positioning
              child: child!,
            );
          },
          child: Hero(
            tag: "dot",
            child: AnimatedBuilder(
              animation: _sizeAnimation,
              builder: (context, child) {
                return child!;
              },
              child: Container(
                width: _sizeAnimation.value,
                height: _sizeAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: yellow,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
