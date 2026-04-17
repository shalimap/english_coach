import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../model/audioanswer.dart';

class AudioAnswers with ChangeNotifier {
  List<AudioAnswer> _audioAnswers = [];

  List<AudioAnswer> get audioAnswers {
    return [..._audioAnswers];
  }

  List<AudioAnswer> findAnsByQueNum(int audQueNum) {
    return _audioAnswers
        .where((answer) => answer.audQuesNum == audQueNum)
        .toList();
  }

  Future<List<AudioAnswer>> fetchAnswer(int audQuesNum) async {
    var parameters = {
      'audQuesNum': audQuesNum.toString()
    }; // audNum in api it should be audQuesNum
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/audio/audioanswer.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<AudioAnswer> audioAnswer = [];
        for (var i = 0; i < extractedData.length; i++) {
          var answer = AudioAnswer.fromJson(extractedData[i]);
          audioAnswer.add(answer);
        }
        _audioAnswers = audioAnswer;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      // throw (error);
    }
    return _audioAnswers;
  }
}
