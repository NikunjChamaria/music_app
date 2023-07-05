// ignore_for_file: constant_identifier_names, depend_on_referenced_packages

import 'dart:convert';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/widgets/height.dart';
import 'package:music_app/widgets/textstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../backend/global_variables.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  @override
  void initState() {
    contoller.getCurrentposition();
    super.initState();
  }

  Contoller contoller = Get.find();
  PlaylistController playlistController = Get.find();

  @override
  void dispose() {
    positionSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: GetBuilder<Contoller>(builder: (contoller1) {
          return Column(
            children: [
              Stack(
                children: [
                  CachedMemoryImage(
                      uniqueKey: contoller1.song['name'],
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.cover,
                      bytes: contoller.getImage(
                          contoller1.song['coverImage']['data']['data'])),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 349),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                              Colors.black.withOpacity(0.9),
                            ],
                            stops: const [0.0, 0.3, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GetBuilder<Contoller>(builder: (contoller1) {
                    return Positioned(
                      bottom: 30,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        contoller1.song['name'],
                                        style:
                                            roboto(white, 20, FontWeight.w800),
                                      ),
                                      Text(contoller1.song['artist'],
                                          style: roboto(
                                              white, 18, FontWeight.w200))
                                    ],
                                  ),
                                  SizedBox(
                                      width: 80,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                              onTap: () async {
                                                Get.snackbar("Downloading",
                                                    '${contoller.song['name']}',
                                                    colorText: black,
                                                    backgroundColor: yellow);
                                                SharedPreferences
                                                    sharedPreferences =
                                                    await SharedPreferences
                                                        .getInstance();

                                                await sharedPreferences
                                                    .setString(
                                                        contoller.song["_id"],
                                                        jsonEncode(
                                                            contoller.song));
                                                Get.snackbar("DOWNLOADED",
                                                    '${contoller.song['name']}',
                                                    colorText: black,
                                                    backgroundColor: yellow);
                                              },
                                              child:
                                                  const Icon(Icons.download)),
                                          const Icon(Icons.favorite_border),
                                        ],
                                      ))
                                ],
                              ),
                              Slider(
                                activeColor: white,
                                value: contoller.currentPosition.inMilliseconds
                                    .toDouble(),
                                onChanged: (val) {
                                  Duration seekPosition =
                                      Duration(milliseconds: val.round());
                                  contoller.audioPlayer.seek(seekPosition);
                                },
                                min: 0.0,
                                max: contoller1.totalDuration.inMilliseconds
                                        .toDouble() +
                                    3000,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${contoller.currentPosition.inMinutes}:${contoller.currentPosition.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                                  ),
                                  Text(
                                    '${contoller1.totalDuration.inMinutes}:${contoller1.totalDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                                  ),
                                ],
                              ),
                              const HeightSpacer(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                      onTap: () async {
                                        if (contoller.currId != -1 &&
                                            contoller.currId != -0) {
                                          contoller.play(
                                              playlistController
                                                  .ids![contoller.currId! - 1],
                                              false,
                                              contoller.currId! - 1);
                                        } else {
                                          Get.snackbar(
                                              "Empty", "No song in queue",
                                              colorText: black,
                                              backgroundColor: yellow);
                                        }
                                      },
                                      child: Container(
                                          height: 80,
                                          decoration: ShapeDecoration(
                                              shape: const CircleBorder(),
                                              color: yellow),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.arrow_back,
                                              size: 30,
                                              color: black,
                                            ),
                                          ))),
                                  GestureDetector(
                                      onTap: () {
                                        contoller.isPlaying
                                            ? {
                                                contoller1.pause(),
                                                contoller.isPlaying = false
                                              }
                                            : {
                                                contoller.getCurrentposition(),
                                                contoller1.resume(),
                                                contoller.initAudioPlayer(),
                                                contoller.onComplete(),
                                                contoller.isPlaying = true
                                              };
                                      },
                                      child: Container(
                                          height: 80,
                                          decoration: ShapeDecoration(
                                              shape: const CircleBorder(),
                                              color: yellow),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                contoller1.isPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                size: 30,
                                                color: black,
                                              )))),
                                  GestureDetector(
                                    onTap: () {
                                      if (contoller.currId != -1 &&
                                          contoller.currId !=
                                              playlistController.ids!.length -
                                                  1) {
                                        contoller.play(
                                            playlistController
                                                .ids![contoller.currId! + 1],
                                            false,
                                            contoller.currId! + 1);
                                      } else {
                                        Get.snackbar(
                                            "Empty", "No song in queue",
                                            colorText: black,
                                            backgroundColor: yellow);
                                      }
                                    },
                                    child: Container(
                                        height: 80,
                                        decoration: ShapeDecoration(
                                            shape: const CircleBorder(),
                                            color: yellow),
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              size: 30,
                                              color: black,
                                            ))),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: yellow,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lyrics",
                                style: roboto(black, 20, FontWeight.w900),
                              ),
                              Icon(
                                Icons.expand,
                                color: black,
                                size: 20,
                              )
                            ],
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Text(
                                  "data",
                                  style: roboto(black, 16, FontWeight.bold),
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
