import 'dart:math';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '/backend/exports.dart';
import 'package:music_app/pages/auth/log_in.dart';
import 'package:music_app/pages/library/downloads.dart';
import 'package:music_app/widgets/height.dart';
import 'package:music_app/widgets/textstyle.dart';
import 'package:music_app/widgets/width.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../music/music.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  Contoller contoller = Get.find();
  Color getRandomColor() {
    final Random random = Random();
    final int r = random.nextInt(256);
    final int g = random.nextInt(256);
    final int b = random.nextInt(256);
    return Color.fromARGB(255, r, g, b);
  }

  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
          child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: getRandomColor(),
                        child: FutureBuilder(
                            future: authController.getNameFirst(),
                            builder: (context, snapshot) {
                              return snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? const Text("")
                                  : Text(
                                      snapshot.data!,
                                      style: roboto(getRandomColor(), 18,
                                          FontWeight.w800),
                                    );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Your library",
                          style: roboto(white, 20, FontWeight.w900),
                        ),
                      )
                    ],
                  ),
                  const HeightSpacer(height: 30),
                  SizedBox(
                    width: double.maxFinite,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(FontAwesomeIcons.music),
                        Padding(
                          padding: const EdgeInsets.only(right: 150),
                          child: Text(
                            "Your Songs",
                            style: roboto(white, 18, FontWeight.w900),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(FontAwesomeIcons.floppyDisk),
                        Padding(
                          padding: const EdgeInsets.only(right: 140),
                          child: Text(
                            "Your Albums",
                            style: roboto(white, 18, FontWeight.w900),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(FontAwesomeIcons.microphone),
                        Padding(
                          padding: const EdgeInsets.only(right: 182),
                          child: Text(
                            "Artitsts",
                            style: roboto(white, 18, FontWeight.w900),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const Downloads());
                    },
                    child: SizedBox(
                      width: double.maxFinite,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(FontAwesomeIcons.download),
                          Padding(
                            padding: const EdgeInsets.only(right: 150),
                            child: Text(
                              "Downloads",
                              style: roboto(white, 18, FontWeight.w900),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  ),
                  const HeightSpacer(height: 10),
                  GestureDetector(
                    onTap: () async {
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences.remove("name");
                      sharedPreferences.remove("email");
                      Get.to(() => const LogIn());
                    },
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 25, right: 25),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: white, width: 2),
                          color: Colors.transparent,
                        ),
                        child: Text(
                          "Log Out",
                          style: roboto(white, 18, FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                  const HeightSpacer(height: 40)
                ],
              ),
            ),
          ),
          GetBuilder<Contoller>(builder: (contoller1) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: contoller.isMusicPlaying
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        width: double.maxFinite,
                        color: yellow,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => const MusicPage(),
                                      transition: Transition.downToUp);
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            child: CachedMemoryImage(
                                              uniqueKey:
                                                  contoller1.song['name'],
                                              bytes: contoller.getImage(
                                                  contoller1.song["coverImage"]
                                                      ['data']['data']),
                                            ))),
                                    const WidthSpacer(width: 5),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          contoller1.song['name'],
                                          style: roboto(
                                              black, 16, FontWeight.w900),
                                        ),
                                        Text(
                                          contoller1.song['artist'],
                                          style: roboto(
                                              black, 16, FontWeight.w400),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const WidthSpacer(width: 60),
                              Icon(
                                Icons.favorite_border,
                                color: black,
                                size: 30,
                              ),
                              GestureDetector(
                                onTap: () {
                                  contoller.isPlaying
                                      ? {
                                          contoller1.pause(),
                                          contoller.isPlaying = false
                                        }
                                      : {
                                          contoller1.resume(),
                                          contoller.getCurrentposition(),
                                          contoller.initAudioPlayer(),
                                          contoller.onComplete(),
                                        };
                                },
                                child: Icon(
                                  contoller1.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: black,
                                  size: 35,
                                ),
                              ),
                              const WidthSpacer(width: 10),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            );
          })
        ],
      )),
    );
  }
}
