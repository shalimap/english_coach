import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/final_qusetions.dart';

class FinaltestQuestions with ChangeNotifier {
  List<Finalquestion> _finalquestions = [];

  List<Finalquestion> get finalquestions => [..._finalquestions];

  Future<List<Finalquestion>> fetchQuestions() async {
    var uri = Uri.https(
      'www.api.englishcoach.app',
      '/api/bin/finaltest/getfinalquestions.php',
    );
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Finalquestion> finalQuestions = [];
        for (var i = 0; i < extractedData.length; i++) {
          var question = Finalquestion.fromJson(extractedData[i]);
          finalQuestions.add(question);
        }
        finalQuestions
            .sort((a, b) => a.finalQuesNumber!.compareTo(b.finalQuesNumber!));
        _finalquestions = finalQuestions;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _finalquestions;
  }

  List<Finalquestion> randomQues() {
    var shuffled = _finalquestions.toList()..shuffle();
    return shuffled;
  }

  Finalquestion findQuestions(int exe) {
    return _finalquestions.firstWhere((que) => que.finalQuesNumber == exe);
  }
}
