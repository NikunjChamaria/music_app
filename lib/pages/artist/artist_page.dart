import 'dart:developer';
import '/backend/exports.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:music_app/constants/colors.dart';
import 'package:music_app/widgets/textstyle.dart';

import '../../widgets/width.dart';
import '../music/music.dart';

class ArtistPage extends StatefulWidget {
  final dynamic artist;
  const ArtistPage({super.key, required this.artist});

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  bool _animationFinished = false;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..addListener(() {
        if (_animationController!.status == AnimationStatus.completed) {
          setState(() {
            _animationFinished = true;
          });
        }
      });
    _animationController!.forward();
  }

  ArtistController artistController = Get.find();
  Contoller contoller = Get.find();
  PlaylistController playlistController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.artist["name"],
      child: !_animationFinished
          ? Scaffold(
              backgroundColor: black,
            )
          : Scaffold(
              backgroundColor: black,
              body: Stack(children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      toolbarHeight: 250,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(children: [
                          CachedMemoryImage(
                            width: MediaQuery.of(context).size.width,
                            height: double.maxFinite,
                            fit: BoxFit.cover,
                            uniqueKey: widget.artist["name"],
                            bytes: artistController.getImageData(
                                widget.artist['artistImage']['data']),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.4),
                                    Colors.black.withOpacity(0.5),
                                  ],
                                  stops: const [0.0, 0.6, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.artist["name"],
                              style: roboto(white, 24, FontWeight.w900),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.play_arrow_outlined,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "${widget.artist["plays"]} plays",
                                  style:
                                      roboto(Colors.grey, 14, FontWeight.bold),
                                )
                              ],
                            ),
                            Stack(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Divider(
                                    color: white,
                                    thickness: 0.5,
                                    endIndent: 60,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () async {
                                      await playlistController
                                          .init(widget.artist['songs']);
                                      dynamic song =
                                          await playlistController.getSongData(
                                              widget.artist['songs'][0]);

                                      contoller.play(song["_id"], false, 0);

                                      contoller.isMusicPlaying = true;
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: yellow,
                                      radius: 25,
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: black,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.artist["songs"].length,
                                itemBuilder: (context, index) {
                                  return FutureBuilder(
                                      future: artistController.getSong(
                                          widget.artist["songs"][index]),
                                      builder: (context, snapshot) {
                                        return snapshot.connectionState ==
                                                ConnectionState.waiting
                                            ? Container()
                                            : GestureDetector(
                                                onTap: () async {
                                                  await playlistController.init(
                                                      widget.artist['songs']);
                                                  contoller.play(
                                                      snapshot.data!["_id"],
                                                      false,
                                                      index);

                                                  contoller.isMusicPlaying =
                                                      true;
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    5)),
                                                        child:
                                                            CachedMemoryImage(
                                                          height: 40,
                                                          width: 40,
                                                          uniqueKey: snapshot
                                                              .data!["name"],
                                                          bytes: artistController
                                                              .getImageData(snapshot
                                                                          .data![
                                                                      "coverImage"]
                                                                  [
                                                                  "data"]["data"]),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              snapshot.data![
                                                                  "name"],
                                                              style: roboto(
                                                                  white,
                                                                  20,
                                                                  FontWeight
                                                                      .bold),
                                                            ),
                                                            Text(snapshot.data![
                                                                    "totalPlays"]
                                                                .toString())
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                      });
                                })
                          ],
                        ),
                      ),
                    ),
                  ],
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                        contoller.song[
                                                                'coverImage']
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
                                        contoller1.isPlaying
                                            ? {
                                                contoller1.pause(),
                                              }
                                            : {
                                                log("1"),
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
            ),
    );
  }
}
