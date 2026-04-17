import 'dart:convert';

import 'package:englishcoach/api/api.dart';
import 'package:englishcoach/pages/audiochattrial/model/audiochatroom.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AudioChatRooms with ChangeNotifier {
  List<AudioChatRoom> _audiochatroom = [];
  List<AudioChatRoom> get audiochatroom => _audiochatroom;

  List<AudioChatRoom> _userchatroom = [];
  List<AudioChatRoom> get userchatroom => _userchatroom;

  Future<void> getAudioChatRooms() async {
    var uri = Uri.parse(Api.getaudiochatrooms);
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<AudioChatRoom> loadedChatRooms = [];
        for (var i = 0; i < extractedData.length; i++) {
          var chatroom = AudioChatRoom.fromJson(extractedData[i]);
          loadedChatRooms.add(chatroom);
        }
        loadedChatRooms.sort((a, b) => a.chatRoomId.compareTo(b.chatRoomId));
        _audiochatroom = loadedChatRooms;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
  }

  Future<List<AudioChatRoom>> searchForChatroom(String userId) async {
    var uri = Uri.parse(Api.searchforchatroom);
    var parameters = {"userId": userId, "active": "1"};
    List<AudioChatRoom> _currentChatroom = [];
    try {
      var response = await http.post(uri, body: parameters);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<AudioChatRoom> userChatRoom = [];
        for (var i = 0; i < extractedData.length; i++) {
          var chatroom = AudioChatRoom.fromJson(extractedData[i]);
          userChatRoom.add(chatroom);
        }
        userChatRoom.sort((a, b) => b.chatRoomId.compareTo(a.chatRoomId));
        _userchatroom = userChatRoom;
        _currentChatroom = userchatroom;
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
    return _currentChatroom;
  }

  Future<String> insertChatroom(String audioContentId, String userId) async {
    var uri = Uri.parse(Api.insertchatroom);
    var parameters = {
      "chatContentId": audioContentId,
      "userId": userId,
    };
    String _id = '';
    try {
      var response = await http.post(uri, body: parameters);
      if (response.statusCode == 200) {
        String extractedData = (response.body);
        if (extractedData.isNotEmpty) {
          _id = extractedData;
        }
      }
    } catch (error) {
      throw (error);
    }
    return _id;
  }

  Future<void> updateAudioStatus(String audioChatRoomId) async {
    var uri = Uri.parse(Api.updatetaudiostatus);
    var parameters = {
      "audioChatRoomId": audioChatRoomId,
    };
    try {
      var response = await http.post(uri, body: parameters);
      if (response.statusCode == 200) {
        print('Status Updated');
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateChatExit(String audioChatRoomId) async {
    var uri = Uri.parse(Api.updatechatexit);
    var parameters = {
      "audioChatRoomId": audioChatRoomId,
    };
    try {
      var response = await http.post(uri, body: parameters);
      print(response);
      if (response.statusCode == 200) {
        print('Exit Updated');
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateAudioUrl(
      String audioChatRoomId, String firebaseurl) async {
    var uri = Uri.parse(Api.updateaudiourl);
    var parameters = {
      "audioChatRoomId": audioChatRoomId,
      "firebaseUrl": firebaseurl,
    };
    if (firebaseurl != '') {
      try {
        var response = await http.post(uri, body: parameters);
        if (response.statusCode == 200) {
          print('Exit Updated');
        }
      } catch (error) {
        throw (error);
      }
    }
  }
}
