import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_app/constants/colors.dart';
import 'package:music_app/widgets/height.dart';
import 'package:music_app/widgets/textstyle.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellow,
      body: Stack(
        children: [
          CachedNetworkImage(
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
              imageUrl: "https://cdn.wallpapersafari.com/58/42/YOdPGA.jpg"),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.6),
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Only Music",
                style: lukiest(yellow, 50, FontWeight.w900),
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            left: 20,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Listen to over",
                  style: roboto(white, 40, FontWeight.w600),
                ),
                const HeightSpacer(height: 5),
                Text(
                  "10000+ songs",
                  style: roboto(white, 45, FontWeight.w900),
                ),
                const HeightSpacer(height: 5),
                Text(
                  "From around the world",
                  maxLines: 2,
                  style: roboto(white, 35, FontWeight.w600),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
