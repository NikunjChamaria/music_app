import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/constants/colors.dart';
import 'package:music_app/pages/auth/log_in.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/textstyle.dart';

class PageFour extends StatelessWidget {
  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<bool> checkPermission() async {
    ///For Check permission..
    await Permission.manageExternalStorage.request();
    if (Platform.isAndroid && await Permission.manageExternalStorage.isDenied) {
      await Get.dialog(CupertinoAlertDialog(
        title: const Text("Photos & Videos permission"),
        content: const Text(
            " Photos & Videos permission should be granted to connect with device, would you like to go to app settings to give Bluetooth & Location permissions?"),
        actions: <Widget>[
          TextButton(
              child: const Text('No thanks'),
              onPressed: () {
                Get.back();
              }),
          TextButton(
              child: const Text('Ok'),
              onPressed: () async {
                Get.back();
                await openAppSettings();
              })
        ],
      ));
      return false;
    } else {
      return true;
    }
  }

  const PageFour({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Stack(
        children: [
          CachedNetworkImage(
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
              imageUrl:
                  "https://images.unsplash.com/photo-1503300961747-204cbbdaeb51?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bXVzaWMlMjBsaXN0ZW58ZW58MHx8MHx8fDA%3D&w=1000&q=80"),
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
            bottom: 200,
            right: 20,
            child: Text(
              "Lets get started",
              style: roboto(white, 50, FontWeight.w900),
            ),
          ),
          GestureDetector(
            onTap: () async {
              var yo = await checkPermission();
              yo
                  ? Get.to(() => const LogIn())
                  : Get.snackbar("Error", "Storage Permission denied");
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: yellow),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 20, left: 90, right: 90),
                      child: Text(
                        "Continue",
                        style: roboto(black, 20, FontWeight.w500),
                      ),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
