import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/module_question.dart';

class ModuleQuestions with ChangeNotifier {
  List<ModuleQuestion> _moduleQuestions = [];

  List<ModuleQuestion> get moduleQuestions {
    return [..._moduleQuestions];
  }

  Future<List<ModuleQuestion>> fetchQuestions(int topicId, int modId) async {
    var parameters = {
      'topicNum': topicId.toString(),
      'modId': modId.toString()
    };
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/moduletest/getmodulequestions.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<ModuleQuestion> moduleQuestion = [];
        for (var i = 0; i < extractedData.length; i++) {
          var question = ModuleQuestion.fromJson(extractedData[i]);
          moduleQuestion.add(question);
        }
        moduleQuestion.sort((a, b) => a.modQueNum!.compareTo(b.modQueNum!));
        _moduleQuestions = moduleQuestion;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _moduleQuestions;
  }

  List<ModuleQuestion> randomQues() {
    var shuffled = _moduleQuestions.toList()..shuffle();
    return shuffled;
  }

  List<ModuleQuestion> totalModQuestions(int mod) {
    return _moduleQuestions.where((ques) => ques.modId == mod).toList();
  }

  ModuleQuestion findById(int quesNum) {
    return _moduleQuestions.firstWhere((ques) => ques.modQueNum == quesNum);
  }
}
