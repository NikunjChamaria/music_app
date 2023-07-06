import 'dart:math';

import 'package:cached_memory_image/cached_memory_image.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/constants/colors.dart';
import '/backend/exports.dart';

import '../../widgets/height.dart';
import '../../widgets/textstyle.dart';
import '../../widgets/width.dart';
import '../music/music.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Contoller contoller = Get.find();
  TextEditingController search = TextEditingController();
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
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 10, left: 10, right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: white, width: 2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          style: roboto(white, 20, FontWeight.bold),
                          showCursor: false,
                          controller: search,
                          decoration: InputDecoration(
                              suffixIconColor: white,
                              prefixIcon: const Icon(Icons.search),
                              focusColor: Colors.transparent,
                              focusedBorder: InputBorder.none,
                              hintText: "Search",
                              hintStyle: roboto(white, 20, FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      "Your recent searches",
                      style: roboto(white, 20, FontWeight.w500),
                    ),
                  ),
                  FutureBuilder(
                      future: authController.getHistory(),
                      builder: (context, snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? Container()
                            : GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 16 / 9,
                                  crossAxisCount: 2,
                                ),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return FutureBuilder(
                                      future: authController
                                          .getSong(snapshot.data![index]["id"]),
                                      builder: (context, snap) {
                                        return snap.connectionState ==
                                                ConnectionState.waiting
                                            ? Container()
                                            : GestureDetector(
                                                onTap: () async {
                                                  contoller.play(
                                                      snap.data!["_id"],
                                                      false,
                                                      -1);

                                                  contoller.isMusicPlaying =
                                                      true;
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    5)),
                                                        color: yellow),
                                                    height: 20,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    child: Stack(
                                                      children: [
                                                        Positioned(
                                                          right: -30,
                                                          top: 12,
                                                          child: Transform(
                                                            transform: Matrix4
                                                                .rotationZ(
                                                                    pi / 6),
                                                            child: Container(
                                                              height: 60,
                                                              width: 60,
                                                              decoration: BoxDecoration(
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        color:
                                                                            black,
                                                                        blurRadius:
                                                                            4,
                                                                        offset: const Offset(
                                                                            -1,
                                                                            -1))
                                                                  ],
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              5))),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            5)),
                                                                child:
                                                                    CachedMemoryImage(
                                                                  uniqueKey: snap
                                                                          .data[
                                                                      'name'],
                                                                  bytes: contoller.getImage(
                                                                      snap.data['coverImage']
                                                                              [
                                                                              'data']
                                                                          [
                                                                          'data']),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            snap.data['name'],
                                                            style: roboto(
                                                                black,
                                                                15,
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                      });
                                },
                              );
                      }),
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
