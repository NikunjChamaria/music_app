// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/backend/controllers/authcontroller.dart';

import '../../constants/server.dart';

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

    changecurr(index);

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
