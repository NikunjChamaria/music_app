// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:music_app/constants/colors.dart';
import 'package:music_app/constants/server.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

StreamSubscription<Duration>? positionSubscription;

class MyCustomSource extends StreamAudioSource {
  final Uint8List bytes;

  MyCustomSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}

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

class Contoller extends GetxController {
  bool isMusicPlaying = false;
  final RxBool _isPlaying = RxBool(true);
  bool get isPlaying => _isPlaying.value;
  set isPlaying(bool value) {
    _isPlaying.value = value;
  }

  Duration currentPosition = const Duration();
  Duration totalDuration = const Duration();
  AudioPlayer audioPlayer = AudioPlayer();
  Future<List> getSongs() async {
    var response = await http.post(Uri.parse(GETSONGS));
    List data = jsonDecode(response.body);
    return data;
  }

  Future<List> gettop10week() async {
    var response = await http.get(Uri.parse(GETTOP10WEEK));
    List data = jsonDecode(response.body);
    return data;
  }

  void getCurrentposition() {
    positionSubscription = audioPlayer.positionStream.listen((duration) {
      currentPosition = duration;

      update();
    });
  }

  dynamic song = {};

  Future<void> getSong(String id) async {
    var response = await http.post(Uri.parse(GETSONGDATA + id));
    song = jsonDecode(response.body);
  }

  Future<List> getImageData() async {
    // print(song['coverImage']);
    return await song['coverImage']['data']['data'];
  }

  Future<void> updateWeekly(String id) async {
    var response = await http.post(Uri.parse(UPDATEWEEKLY + id));
  }

  Future<List> getTop100main() async {
    var response = await http.get(Uri.parse(GETTOP100MAIN));
    List data = jsonDecode(response.body);
    return data;
  }

  Future<List> getTop100() async {
    var response = await http.get(Uri.parse(GETTOP100));
    List data = jsonDecode(response.body);
    return data;
  }

  Future<List> getenglish() async {
    var response = await http.get(Uri.parse(GETENGLISH));
    List data = jsonDecode(response.body);
    return data;
  }

  Future<List> gethindi() async {
    var response = await http.get(Uri.parse(GETHINDI));
    List data = jsonDecode(response.body);
    return data;
  }

  int? currId;
  void changecurr(int newvalue) {
    currId = newvalue;
  }

  void play(String id, bool isPlaylist, int index) async {
    audioPlayer.stop();
    await getSong(id);
    _isPlaying.value = true;
    log(index.toString());
    changecurr(index);
    log(currId.toString());

    await updateWeekly(id);
    await AuthController().updateHistory(id, isPlaylist);
    initAudioPlayer();

    Uint8List uint8List =
        Uint8List.fromList(song['mp3File']['data']['data'].cast<int>());
    final source = MyCustomSource(uint8List);
    await audioPlayer.setAudioSource(source);
    await audioPlayer.play();
    onComplete();

    update();
  }

  Uint8List getImage(List<dynamic> data) {
    Uint8List uint8List = Uint8List.fromList(data.cast<int>());
    return uint8List;
  }

  void pause() {
    audioPlayer.pause();
    _isPlaying.value = false;
    update();
  }

  void resume() {
    audioPlayer.play();
    _isPlaying.value = true;
    update();
  }

  void onComplete() {
    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        currentPosition = const Duration();
        _isPlaying.value = false;
        //update();
      }
    });
  }

  void initAudioPlayer() async {
    audioPlayer.durationStream.listen((duration) {
      totalDuration = duration!;
      update();
    });
  }
}

class ArtistController extends GetxController {
  Future<List> getArtist() async {
    var response = await http.get(Uri.parse(GETARTIST));
    List data = jsonDecode(response.body);
    return data;
  }

  Uint8List getImageData(List<dynamic> data) {
    Uint8List uint8list = Uint8List.fromList(data.cast<int>());
    return uint8list;
  }

  Future<dynamic> getSong(String id) async {
    var response = await http.post(Uri.parse(GETSONG + id));
    dynamic song = jsonDecode(response.body);
    return song;
  }

  Future<dynamic> getSongData(String id) async {
    var response = await http.post(Uri.parse(GETSONG + id));
    dynamic song = jsonDecode(response.body);
    return song;
  }
}

class PlaylistController extends GetxController {
  Future<dynamic> getplayslistbyname(String name) async {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var resposne = await http.post(Uri.parse(GETPLAYLISTBYNAME),
        headers: headers, body: jsonEncode({"name": name}));
    dynamic data = jsonDecode(resposne.body);
    return data;
  }

  Uint8List getImageData(List<dynamic> data) {
    Uint8List uint8list = Uint8List.fromList(data.cast<int>());
    return uint8list;
  }

  Future<dynamic> getSong(String id) async {
    var response = await http.post(Uri.parse(GETSONG + id));
    dynamic song = jsonDecode(response.body);
    return song;
  }

  Future<dynamic> getSongData(String id) async {
    var response = await http.post(Uri.parse(GETSONGDATA + id));
    dynamic song = jsonDecode(response.body);
    return song;
  }

  List<String>? ids;
  Future<void> init(List<dynamic> data) async {
    ids = data.map((e) => e.toString()).toList();
    log(ids.toString());
  }
}
