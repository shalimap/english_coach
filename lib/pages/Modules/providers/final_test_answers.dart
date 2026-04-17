import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/final_answers.dart';

class FinaltestAnswers with ChangeNotifier {
  List<Finalanswer> _finalanswers = [];

  List<Finalanswer> get finalanswers => [..._finalanswers];

  Future<List<Finalanswer>> fetchAnswer(finalQuesNum) async {
    var parameters = {'finalQuesNum': finalQuesNum.toString()};
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/bin/finaltest/getfinalanswers.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /*  headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Finalanswer> finalAnswers = [];
        for (var i = 0; i < extractedData.length; i++) {
          var answer = Finalanswer.fromJson(extractedData[i]);
          finalAnswers.add(answer);
        }
        _finalanswers = finalAnswers;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _finalanswers;
  }
}
