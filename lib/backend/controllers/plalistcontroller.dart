import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:music_app/constants/server.dart';

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
  }
}
