import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_app/constants/colors.dart';

import '../../widgets/height.dart';
import '../../widgets/textstyle.dart';

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellow,
      body: Stack(
        children: [
          CachedNetworkImage(
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
              imageUrl:
                  "https://rukminim2.flixcart.com/image/850/1000/ja9yg7k0/poster/e/g/a/medium-marshmello-ab3257-original-imaezw4crht9wnxj.jpeg?q=90"),
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
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
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
            top: 420,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Find Music",
                  style: roboto(white, 50, FontWeight.w900),
                ),
                const HeightSpacer(height: 5),
                Text(
                  "from your favourite",
                  maxLines: 2,
                  style: roboto(white, 40, FontWeight.w600),
                ),
                const HeightSpacer(height: 5),
                Text(
                  "ARTISTS",
                  maxLines: 2,
                  style: roboto(white, 55, FontWeight.w900),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
