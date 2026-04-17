import 'package:englishcoach/api/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/answer.dart';

class PrelimTransAnswers with ChangeNotifier {
  List<PrelimTransAnswer> _transAnswer = [];

  List<PrelimTransAnswer> get transAnswers {
    return [..._transAnswer];
  }

  List<PrelimTransAnswer> findAnsByQueNum(int queNum) {
    return _transAnswer
        .where((answer) => answer.prelimTransQuesNum == queNum)
        .toList();
  }

  Future<List<PrelimTransAnswer>> fetchAnswer(int transQuesNum) async {
    var parameters = {'transQuesNum': transQuesNum.toString()};
    var uri = Uri.parse(Api.baseUrl +
        'exp/preliminary_2/getanswer.php?transQuesNum=${transQuesNum.toString()}');
    /* var uri = Uri.https('www.api.englishcoach.app',
        '/api/exp/preliminary_2/getanswer.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"}; */
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<PrelimTransAnswer> transAnswers = [];
        for (var i = 0; i < extractedData.length; i++) {
          var answer = PrelimTransAnswer.fromJson(extractedData[i]);
          transAnswers.add(answer);
        }
        _transAnswer = transAnswers;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
    }
    return _transAnswer;
  }
}
