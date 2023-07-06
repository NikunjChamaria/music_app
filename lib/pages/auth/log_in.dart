import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/backend/exports.dart';
import 'package:music_app/constants/colors.dart';
import 'package:music_app/pages/auth/register.dart';
import 'package:music_app/pages/home/home.dart';
import 'package:music_app/widgets/height.dart';
import 'package:music_app/widgets/textstyle.dart';
import 'package:music_app/widgets/width.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  AuthController authController = Get.find();

  bool isShowing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100)),
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(black, BlendMode.exclusion),
                      fit: BoxFit.cover,
                      image: const CachedNetworkImageProvider(
                          "https://st3.depositphotos.com/1017986/18353/i/600/depositphotos_183537454-stock-photo-man-with-headphones-singing-at.jpg"))),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Text(
                    "Log in",
                    style: roboto(white, 45, FontWeight.bold),
                  ),
                ),
              ),
            ),
            const HeightSpacer(height: 90),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 10, left: 40, right: 40),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: white, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    style: roboto(white, 20, FontWeight.bold),
                    showCursor: false,
                    controller: email,
                    decoration: InputDecoration(
                        focusColor: Colors.transparent,
                        focusedBorder: InputBorder.none,
                        hintText: "Email",
                        hintStyle: roboto(white, 20, FontWeight.bold)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 10, left: 40, right: 40),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: white, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    style: roboto(white, 20, FontWeight.bold),
                    showCursor: false,
                    controller: password,
                    obscureText: isShowing,
                    decoration: InputDecoration(
                        suffixIconColor: white,
                        suffixIcon: IconButton(
                          icon: isShowing
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              isShowing = !isShowing;
                            });
                          },
                        ),
                        focusColor: Colors.white,
                        focusedBorder: InputBorder.none,
                        hintText: "Password",
                        hintStyle: roboto(white, 20, FontWeight.bold)),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await authController.login(email.text, password.text) == true
                    ? Get.to(() => const HomePage(),
                        transition: Transition.size)
                    : Get.snackbar("Error", "Login Failed");
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: white, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 50, right: 50, top: 10, bottom: 10),
                  child: Text(
                    "Log in",
                    style: roboto(white, 18, FontWeight.w900),
                  ),
                ),
              ),
            ),
            const HeightSpacer(height: 240),
            Row(
              children: [
                const WidthSpacer(width: 20),
                Text(
                  "Don't have an account? you can",
                  style: roboto(white, 16, FontWeight.bold),
                ),
                const WidthSpacer(width: 10),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const Register(),
                        transition: Transition.leftToRightWithFade);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: yellow,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 30, right: 30, bottom: 10),
                      child: Text(
                        "Sign up",
                        style: roboto(black, 20, FontWeight.w900),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
