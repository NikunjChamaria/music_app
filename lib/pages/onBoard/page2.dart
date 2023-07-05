import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_app/constants/colors.dart';

import '../../widgets/height.dart';
import '../../widgets/textstyle.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

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
                  "https://i.pinimg.com/736x/59/cd/9e/59cd9e3ed12822cc8ba7fbade86f2d92.jpg"),
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
                  "Share your talent",
                  style: roboto(white, 40, FontWeight.w900),
                ),
                const HeightSpacer(height: 5),
                Text(
                  "and get recognized",
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
