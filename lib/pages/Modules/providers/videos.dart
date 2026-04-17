import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../models/video.dart';

class ModuleVideos with ChangeNotifier {
  List<Modulevideo> _videos = [];

  List<Modulevideo> get videos {
    return [..._videos];
  }

  Modulevideo findVideo(int modId) {
    return _videos.firstWhere((vid) => vid.modId == modId.toString());
  }

  // List<Modulevideo> findVideos(int modId) {
  //   return _videos.where((vid) => vid.modId == modId).toList();
  // }

  Future fetchVideos(int id) async {
    var parameters = {'modId': id.toString()};
    var uri = Uri.https(
        'www.api.englishcoach.app', '/api/bin/pictogram/video.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Modulevideo> loadedVideos = [];
        for (var i = 0; i < extractedData.length; i++) {
          var video = Modulevideo.fromJson(extractedData[i]);
          loadedVideos.add(video);
        }
        loadedVideos.sort((a, b) => a.modId!.compareTo(b.modId!));
        _videos = loadedVideos;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _videos;
  }
}
