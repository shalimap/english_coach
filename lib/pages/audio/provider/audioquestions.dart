import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../model/audioquestion.dart';

class AudioQuestions with ChangeNotifier {
  List<AudioQuestion> _audioQuestions = [];

  List<AudioQuestion> get audioQuestions {
    return [..._audioQuestions];
  }

  Future<List<AudioQuestion>> fetchQuestions(int audNum) async {
    var parameters = {
      'audNum': audNum.toString(),
    };
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/audio/audioquestion.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<AudioQuestion> audioQuestion = [];
        for (var i = 0; i < extractedData.length; i++) {
          var question = AudioQuestion.fromJson(extractedData[i]);
          audioQuestion.add(question);
        }
        _audioQuestions = audioQuestion;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _audioQuestions;
  }

  List<AudioQuestion> randomQues() {
    var shuffled = _audioQuestions.toList()..shuffle();
    return shuffled;
  }

  List<AudioQuestion> totalAudQuestions(int aud) {
    return _audioQuestions.where((ques) => ques.audQuesNum == aud).toList();
  }

  List<AudioQuestion> findById(int quesNum) {
    return _audioQuestions.where((ques) => ques.audQuesNum == quesNum).toList();
  }
}
