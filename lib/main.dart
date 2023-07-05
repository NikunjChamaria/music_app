import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/pages/splash_sceen/splash.dart';

import 'backend/global_variables.dart';

void main() {
  Get.lazyPut(() => Contoller());
  Get.lazyPut(() => AuthController());
  Get.lazyPut(() => ArtistController());
  Get.lazyPut(() => PlaylistController());
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Only Music',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}
