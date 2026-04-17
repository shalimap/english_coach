import 'package:englishcoach/api/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/question.dart';

class PrelimTransQuestions with ChangeNotifier {
  List<PrelimTransQuestion> _transQuestions = [];

  List<PrelimTransQuestion> get transQuestions {
    return [..._transQuestions];
  }

  Future<List<PrelimTransQuestion>> fetchQuestions() async {
    var uri = Uri.parse(Api.baseUrl + 'exp/preliminary_2/getquestions.php');
    /*   var uri = Uri.https(
        'www.api.englishcoach.app', '/api/exp/preliminary_2/getquestions.php');
    Map<String, String> headers = {"Content-Type": "application/json"}; */
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<PrelimTransQuestion> transQuestions = [];
        for (var i = 0; i < extractedData.length; i++) {
          var question = PrelimTransQuestion.fromJson(extractedData[i]);
          transQuestions.add(question);
        }
        transQuestions.sort(
            (a, b) => a.prelimTransQuesNum!.compareTo(b.prelimTransQuesNum!));
        _transQuestions = transQuestions;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _transQuestions;
  }

  List<PrelimTransQuestion> randomQues() {
    var shuffled = _transQuestions.toList()..shuffle();
    return shuffled;
  }

  List<PrelimTransQuestion> totalTopicQuestions(int topic) {
    return _transQuestions.where((ques) => ques.tNum == topic).toList();
  }

  PrelimTransQuestion findById(int quesNum) {
    return _transQuestions
        .firstWhere((ques) => ques.prelimTransQuesNum == quesNum);
  }

  PrelimTransQuestion findQuestions(int exe) {
    return _transQuestions.firstWhere((que) => que.prelimTransQuesNum == exe);
  }
}
