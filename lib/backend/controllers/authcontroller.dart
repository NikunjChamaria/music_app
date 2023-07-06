// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:music_app/constants/colors.dart';
import 'package:music_app/constants/server.dart';
import 'package:http/http.dart' as http;
import 'package:palette_generator/palette_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  Future<bool> login(String email, String password) async {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var response = await http.post(Uri.parse(LOGIN),
        headers: headers,
        body: jsonEncode({"email": email, "password": password}));
    dynamic data = jsonDecode(response.body);
    Map<String, dynamic> token = JwtDecoder.decode(data["token"]);
    if (data["status"] == true) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("name", token["name"]);
      sharedPreferences.setString("email", token["email"]);
      return true;
    }
    return false;
  }

  Future<bool> register(
      String email, String password, String name, String phone) async {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var response = await http.post(Uri.parse(REGISTER),
        headers: headers,
        body: jsonEncode({
          "email": email,
          "password": password,
          "name": name,
          "phone": phone
        }));
    dynamic data = jsonDecode(response.body);
    if (data["status"] == true) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("name", name);
      sharedPreferences.setString("email", email);
      return true;
    }
    return false;
  }

  Future<String> getNameFirst() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String name = sharedPreferences.getString("name")!;
    return name[0];
  }

  Future<List> getHistory() async {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String email = sharedPreferences.getString("email")!;
    var response = await http.post(Uri.parse(GETHISTORY),
        headers: headers, body: jsonEncode({"email": email}));
    List data = jsonDecode(response.body);
    return data;
  }

  Future<void> updateHistory(String id, bool isPlaylist) async {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String email = sharedPreferences.getString("email")!;
    var response = await http.post(Uri.parse(UPDATEHISTORY),
        headers: headers,
        body: jsonEncode({"email": email, "id": id, "isPlaylist": isPlaylist}));
  }

  Future<dynamic> getSong(String id) async {
    var response = await http.post(Uri.parse(GETSONG + id));
    dynamic song = jsonDecode(response.body);
    return song;
  }

  Future<Color> extractDominantColor(
      Uint8List uint8list, int width, int height) async {
    ByteData byteData = ByteData.view(uint8list.buffer);
    final paletteGenerator = await PaletteGenerator.fromByteData(
        EncodedImage(byteData, width: width, height: height));
    return paletteGenerator.dominantColor?.color ?? white;
  }
}
