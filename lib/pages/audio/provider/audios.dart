import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../model/audio.dart';

class Audios with ChangeNotifier {
  List<Audio> _audios = [];

  List<Audio> get audios {
    return [..._audios];
  }

  set chapters(List<Audio> val) {
    _audios = val;
    notifyListeners();
  }

  Audio findById(int id) {
    return _audios.firstWhere((aud) => aud.audNum == id);
  }

  nextAudioId(int count) {
    return (_audios.skip(count).first.audNum);
  }

  // Future<String> fetchLevel(int id) async {
  //   String level;

  //   var parameters = {'userId': id.toString()};
  //   var uri = Uri.https(
  //       'www.api.englishcoach.app', '/api/dev/level/getlevel.php', parameters);
  //   Map<String, String> headers = {"Content-Type": "application/json"};
  //   try {
  //     var response = await http.get(uri, headers: headers);
  //     if (response.statusCode == 200) {
  //       var levelData = json.decode(response.body);
  //       String userLevel = levelData[0]['sl_level'].toString();
  //       level = userLevel;
  //     }
  //   } catch (error) {
  //     print('ERROR : ' + error.toString());
  //     throw (error);
  //   }
  //   return level;
  // }

  Future<List<Audio>> fetchAudios() async {
    var uri =
        Uri.https('www.api.englishcoach.app', '/api/dev/audio/audios.php');
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /*  headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Audio> loadedAudios = [];
        for (var i = 0; i < extractedData.length; i++) {
          var audio = Audio.fromJson(extractedData[i]);
          loadedAudios.add(audio);
        }
        loadedAudios.sort((a, b) => a.audNum!.compareTo(b.audNum!));
        _audios = loadedAudios;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _audios;
  }
}
