import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/backend/exports.dart';
import 'package:music_app/constants/colors.dart';
import 'package:music_app/pages/music/music.dart';
import 'package:music_app/widgets/textstyle.dart';
import 'package:music_app/widgets/width.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Downloads extends StatefulWidget {
  const Downloads({super.key});

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  Future<List<dynamic>> getdata() async {
    List<dynamic> downloads = [];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Set<String> keys = sharedPreferences.getKeys();
    for (var n in keys) {
      if (n != "name" && n != "email") {
        //sharedPreferences.remove(n);
        downloads.add(jsonDecode(sharedPreferences.getString(n)!));
      }
    }
    return downloads;
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  Contoller contoller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Stack(children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Downloads",
                  style: roboto(white, 30, FontWeight.w900),
                ),
                FutureBuilder(
                    future: getdata(),
                    builder: (context, snapshot) {
                      return snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              snapshot.data!.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 350),
                                child: Text(
                                  "NO DOWNLOADS",
                                  style: roboto(white, 45, FontWeight.w800),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      contoller.play(
                                          snapshot.data![index]["_id"],
                                          false,
                                          -1);

                                      contoller.isMusicPlaying = true;
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      width: double.maxFinite,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 60,
                                                width: 60,
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  child: CachedMemoryImage(
                                                    uniqueKey: snapshot
                                                        .data![index]['name'],
                                                    bytes: Uint8List.fromList(
                                                        snapshot.data![index]
                                                                ["coverImage"]
                                                                ["data"]["data"]
                                                            .cast<int>()),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snapshot.data![index]
                                                          ["name"],
                                                      style: roboto(white, 18,
                                                          FontWeight.w600),
                                                    ),
                                                    Text(
                                                      snapshot.data![index]
                                                          ["artist"],
                                                      style: roboto(white, 14,
                                                          FontWeight.w300),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              SharedPreferences
                                                  sharedPreferences =
                                                  await SharedPreferences
                                                      .getInstance();
                                              sharedPreferences.remove(
                                                  snapshot.data![index]["_id"]);
                                              setState(() {});
                                            },
                                            child: const Icon(
                                              Icons.delete,
                                              color: white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                    })
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
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          child: CachedMemoryImage(
                                            uniqueKey: contoller1.song['name'],
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
                                        style:
                                            roboto(black, 16, FontWeight.w900),
                                      ),
                                      Text(
                                        contoller1.song['artist'],
                                        style:
                                            roboto(black, 16, FontWeight.w400),
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
      ]),
    );
  }
}
