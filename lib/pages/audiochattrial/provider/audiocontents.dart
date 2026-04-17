import 'dart:convert';
import 'dart:math';

import 'package:englishcoach/api/api.dart';
import 'package:englishcoach/pages/audiochattrial/model/audiocontent.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AudioContents with ChangeNotifier {
  List<AudioContent> _audiocontent = [];
  List<AudioContent> get audiocontent => _audiocontent;

  Future<void> getAudioChatContents() async {
    var uri = Uri.parse(Api.getaudiocontents);
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<AudioContent> loadedContents = [];
        for (var i = 0; i < extractedData.length; i++) {
          var content = AudioContent.fromJson(extractedData[i]);
          loadedContents.add(content);
        }
        loadedContents
            .sort((a, b) => a.audioContentId.compareTo(b.audioContentId));
        _audiocontent = loadedContents;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
  }

  Future<bool> getAudioChatContentById(String contentId) async {
    var uri = Uri.parse(Api.getaudiocontentbyid);
    var parameter = {'contentId': contentId};
    bool success = false;
    try {
      await http.post(uri, body: parameter).then((response) {
        if (response.statusCode == 200) {
          List extractedData = json.decode(response.body);
          List<AudioContent> loadedContents = [];
          for (var i = 0; i < extractedData.length; i++) {
            var content = AudioContent.fromJson(extractedData[i]);
            loadedContents.add(content);
          }
          loadedContents
              .sort((a, b) => a.audioContentId.compareTo(b.audioContentId));
          _audiocontent = loadedContents;
          success = true;
          notifyListeners();
          return success;
        } else {
          print('Fetch Failed');
          return success;
        }
      });
      return success;
    } catch (error) {
      print('ERROR : $error');
      throw (error);
    }
  }

  AudioContent getAudioContentById(String contentId) {
    return _audiocontent.firstWhere((e) => e.audioContentId == contentId);
  }
}
