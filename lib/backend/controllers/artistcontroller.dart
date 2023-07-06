import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../constants/server.dart';

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
