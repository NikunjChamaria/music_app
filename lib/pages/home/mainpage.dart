import 'dart:typed_data';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:cached_memory_image/provider/cached_memory_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/constants/colors.dart';
import '/backend/exports.dart';
import 'package:music_app/pages/artist/artist_page.dart';
import 'package:music_app/pages/music/music.dart';
import 'package:music_app/pages/playlist/playlist_page.dart';
import 'package:music_app/widgets/height.dart';
import 'package:music_app/widgets/textstyle.dart';
import 'package:music_app/widgets/width.dart';
import 'package:shimmer/shimmer.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime time = DateTime.now();
  SliverGridDelegate sliverGridDelegate =
      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2);
  ScrollController scrollController = ScrollController();

  Contoller contoller = Get.find();
  ArtistController artistController = Get.find();
  PlaylistController playlistController = Get.find();
  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: SingleChildScrollView(
            clipBehavior: Clip.antiAlias,
            physics: const ScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      tileMode: TileMode.decal,
                      colors: [
                        yellow,
                        Colors.transparent,
                      ],
                      stops: const [0, 1.0],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 10),
                      child: Text(
                        time.hour < 12
                            ? "Good Morning"
                            : time.hour < 17
                                ? "Good AfterNoon"
                                : "Good Evening",
                        style: roboto(white, 30, FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                FutureBuilder(
                    future: authController.getHistory(),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                snapshot.data!.isEmpty
                                    ? const SizedBox.shrink()
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Text("Recently Played",
                                            style: roboto(
                                                white, 18, FontWeight.bold)),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data?.length,
                                        itemBuilder: (context, index) {
                                          return snapshot.connectionState ==
                                                  ConnectionState.waiting
                                              ? Shimmer.fromColors(
                                                  baseColor: black,
                                                  highlightColor: Colors.grey,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      height: 100,
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                          color: black),
                                                    ),
                                                  ))
                                              : FutureBuilder(
                                                  future:
                                                      authController.getSong(
                                                          snapshot.data![index]
                                                              ["id"]),
                                                  builder: (context, snap) {
                                                    Uint8List data = snap
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting
                                                        ? Uint8List(0)
                                                        : contoller.getImage(snap
                                                                    .data[
                                                                'coverImage']
                                                            ['data']['data']);
                                                    return snap.connectionState ==
                                                            ConnectionState
                                                                .waiting
                                                        ? Container()
                                                        : GestureDetector(
                                                            onTap: () async {
                                                              contoller.play(
                                                                  snap.data![
                                                                      "_id"],
                                                                  false,
                                                                  -1);

                                                              contoller
                                                                      .isMusicPlaying =
                                                                  true;
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    height: 100,
                                                                    width: 100,
                                                                    decoration: const BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10))),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius: const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              10)),
                                                                      child: CachedMemoryImage(
                                                                          uniqueKey: snap.data[
                                                                              'name'],
                                                                          bytes:
                                                                              data),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            10),
                                                                    child: SizedBox(
                                                                        width: 100,
                                                                        child: Center(
                                                                          child:
                                                                              Text(
                                                                            snap.data['name'],
                                                                            style: roboto(
                                                                                white,
                                                                                16,
                                                                                FontWeight.w400),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        )),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                  });
                                        }),
                                  ),
                                ),
                              ],
                            );
                    }),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Top pick this week",
                          style: roboto(white, 18, FontWeight.bold)),
                      GestureDetector(
                        onTap: () async {
                          await Get.to(() =>
                              const PlaylistPage(name: "Top 10 This Week"));
                        },
                        child: Hero(
                          tag: "Top 10 This Week",
                          child: Row(
                            children: [
                              Text(
                                "See all",
                                style: roboto(yellow, 14, FontWeight.bold),
                              ),
                              Icon(
                                Icons.play_arrow_rounded,
                                color: yellow,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    height: 150,
                    child: FutureBuilder(
                        future: contoller.gettop10week(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) {
                                //print(snapshot.data![index]['_id']);
                                Uint8List data = snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? Uint8List(0)
                                    : contoller.getImage(snapshot.data![index]
                                        ['coverImage']['data']['data']);
                                return snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? Shimmer.fromColors(
                                        baseColor: black,
                                        highlightColor: Colors.grey,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 100,
                                            width: 120,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                color: black),
                                          ),
                                        ))
                                    : GetBuilder<Contoller>(
                                        builder: (contoller1) {
                                        return GestureDetector(
                                          onTap: () async {
                                            contoller.play(
                                                snapshot.data![index]["_id"],
                                                false,
                                                -1);

                                            contoller.isMusicPlaying = true;
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 100,
                                                  width: 100,
                                                  decoration:
                                                      const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    child: CachedMemoryImage(
                                                        uniqueKey: snapshot
                                                                .data![index]
                                                            ['name'],
                                                        bytes: data),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: SizedBox(
                                                      width: 100,
                                                      child: Center(
                                                        child: Text(
                                                          snapshot.data![index]
                                                              ['name'],
                                                          style: roboto(
                                                              white,
                                                              16,
                                                              FontWeight.w400),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                              });
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Text("Creators",
                      style: roboto(white, 18, FontWeight.bold)),
                ),
                FutureBuilder(
                    future: artistController.getArtist(),
                    builder: (context, snapshot) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: SizedBox(
                          height: 150,
                          child: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? Container()
                              : ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Hero(
                                      tag: snapshot.data![index]["name"],
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(() => ArtistPage(
                                              artist: snapshot.data![index]));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 50,
                                                backgroundImage:
                                                    CachedMemoryImageProvider(
                                                        snapshot.data![index]
                                                            ["name"],
                                                        bytes: artistController
                                                            .getImageData(snapshot
                                                                            .data![
                                                                        index][
                                                                    "artistImage"]
                                                                ["data"])),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: SizedBox(
                                                    width: 100,
                                                    child: Center(
                                                      child: Text(
                                                        snapshot.data![index]
                                                            ["name"],
                                                        style: roboto(white, 16,
                                                            FontWeight.w400),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Top 100",
                          style: roboto(white, 18, FontWeight.bold)),
                      GestureDetector(
                        onTap: () async {
                          contoller.getTop100();
                          await Get.to(
                              () => const PlaylistPage(name: "Top 100"));
                        },
                        child: Hero(
                          tag: "Top 100",
                          child: Row(
                            children: [
                              Text(
                                "See all",
                                style: roboto(yellow, 14, FontWeight.bold),
                              ),
                              Icon(
                                Icons.play_arrow_rounded,
                                color: yellow,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    height: 150,
                    child: FutureBuilder(
                        future: contoller.getTop100main(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) {
                                //print(snapshot.data![index]['_id']);
                                Uint8List data = snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? Uint8List(0)
                                    : contoller.getImage(snapshot.data![index]
                                        ['coverImage']['data']['data']);
                                return snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? Shimmer.fromColors(
                                        baseColor: black,
                                        highlightColor: Colors.grey,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 100,
                                            width: 120,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                color: black),
                                          ),
                                        ))
                                    : GetBuilder<Contoller>(
                                        builder: (contoller1) {
                                        return GestureDetector(
                                          onTap: () async {
                                            contoller.play(
                                                snapshot.data![index]["_id"],
                                                false,
                                                -1);

                                            contoller.isMusicPlaying = true;
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 100,
                                                  width: 100,
                                                  decoration:
                                                      const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    child: CachedMemoryImage(
                                                        uniqueKey: snapshot
                                                                .data![index]
                                                            ['name'],
                                                        bytes: data),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: SizedBox(
                                                      width: 100,
                                                      child: Center(
                                                        child: Text(
                                                          snapshot.data![index]
                                                              ['name'],
                                                          style: roboto(
                                                              white,
                                                              16,
                                                              FontWeight.w400),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                              });
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Top 10 in English",
                          style: roboto(white, 18, FontWeight.bold)),
                      GestureDetector(
                        onTap: () async {
                          await Get.to(() =>
                              const PlaylistPage(name: "Top 10 in English"));
                        },
                        child: Hero(
                          tag: "Top 10 in English",
                          child: Row(
                            children: [
                              Text(
                                "See all",
                                style: roboto(yellow, 14, FontWeight.bold),
                              ),
                              Icon(
                                Icons.play_arrow_rounded,
                                color: yellow,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    height: 150,
                    child: FutureBuilder(
                        future: contoller.getenglish(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) {
                                //print(snapshot.data![index]['_id']);
                                Uint8List data = snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? Uint8List(0)
                                    : contoller.getImage(snapshot.data![index]
                                        ['coverImage']['data']['data']);
                                return snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? Shimmer.fromColors(
                                        baseColor: black,
                                        highlightColor: Colors.grey,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 100,
                                            width: 120,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                color: black),
                                          ),
                                        ))
                                    : GetBuilder<Contoller>(
                                        builder: (contoller1) {
                                        return GestureDetector(
                                          onTap: () async {
                                            contoller.play(
                                                snapshot.data![index]["_id"],
                                                false,
                                                -1);

                                            contoller.isMusicPlaying = true;
                                            contoller.isPlaying = true;
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 100,
                                                  width: 100,
                                                  decoration:
                                                      const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    child: CachedMemoryImage(
                                                        uniqueKey: snapshot
                                                                .data![index]
                                                            ['name'],
                                                        bytes: data),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: SizedBox(
                                                      width: 100,
                                                      child: Center(
                                                        child: Text(
                                                          snapshot.data![index]
                                                              ['name'],
                                                          style: roboto(
                                                              white,
                                                              16,
                                                              FontWeight.w400),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                              });
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Top 10 in Hindi",
                          style: roboto(white, 18, FontWeight.bold)),
                      GestureDetector(
                        onTap: () async {
                          await Get.to(() =>
                              const PlaylistPage(name: "Top 10 in Hindi"));
                        },
                        child: Hero(
                          tag: "Top 10 in Hindi",
                          child: Row(
                            children: [
                              Text(
                                "See all",
                                style: roboto(yellow, 14, FontWeight.bold),
                              ),
                              Icon(
                                Icons.play_arrow_rounded,
                                color: yellow,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    height: 150,
                    child: FutureBuilder(
                        future: contoller.gethindi(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) {
                                //print(snapshot.data![index]['_id']);
                                Uint8List data = snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? Uint8List(0)
                                    : contoller.getImage(snapshot.data![index]
                                        ['coverImage']['data']['data']);
                                return snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? Shimmer.fromColors(
                                        baseColor: black,
                                        highlightColor: Colors.grey,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 100,
                                            width: 120,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                color: black),
                                          ),
                                        ))
                                    : GetBuilder<Contoller>(
                                        builder: (contoller1) {
                                        return GestureDetector(
                                          onTap: () async {
                                            contoller.play(
                                                snapshot.data![index]["_id"],
                                                false,
                                                -1);

                                            contoller.isMusicPlaying = true;
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 100,
                                                  width: 100,
                                                  decoration:
                                                      const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    child: CachedMemoryImage(
                                                        uniqueKey: snapshot
                                                                .data![index]
                                                            ['name'],
                                                        bytes: data),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: SizedBox(
                                                      width: 100,
                                                      child: Center(
                                                        child: Text(
                                                          snapshot.data![index]
                                                              ['name'],
                                                          style: roboto(
                                                              white,
                                                              16,
                                                              FontWeight.w400),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                              });
                        }),
                  ),
                ),
                const HeightSpacer(height: 30)
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
                                                contoller.song["coverImage"]
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
