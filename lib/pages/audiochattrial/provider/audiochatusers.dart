import 'dart:convert';

import 'package:englishcoach/api/api.dart';
import 'package:englishcoach/pages/audiochattrial/model/audiochatuser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AudioChatUsers with ChangeNotifier {
  List<AudioChatUser> _audiochatuser = [];
  List<AudioChatUser> get audiochatuser => _audiochatuser;

  Future<void> getAudioChatUsers() async {
    var uri = Uri.parse(Api.getgroupchatroomdetails);
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<AudioChatUser> loadedUsers = [];
        for (var i = 0; i < extractedData.length; i++) {
          var user = AudioChatUser.fromJson(extractedData[i]);
          loadedUsers.add(user);
        }
        loadedUsers.sort((a, b) => a.roomEndTime.compareTo(b.roomEndTime));
        _audiochatuser = loadedUsers;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
  }
}
