import 'package:englishcoach/api/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../models/video.dart';

class TrialVideo with ChangeNotifier {
  List<Video> _videos = [];

  List<Video> get videos {
    return [..._videos];
  }

  Video findVideo(int modId) {
    return _videos.firstWhere((vid) => vid.modId == modId);
  }

  List<Video> findVideos(int modId) {
    return _videos.where((vid) => vid.modId == modId).toList();
  }

  Future fetchVideos(int id) async {
    var parameters = {'modId': id.toString()};
    // var uri = Uri.https(
    //     'www.api.englishcoach.app', '/api/dev/trial/video.php', parameters);
    // Map<String, String> headers = {"Content-Type": "application/json"};

    var uri =
        Uri.parse(Api.baseUrl + 'dev/trial/video.php?modId=${id.toString()}');
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Video> loadedVideos = [];
        for (var i = 0; i < extractedData.length; i++) {
          var video = Video.fromJson(extractedData[i]);
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
  }
}
