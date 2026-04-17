import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/module_answer.dart';

class ModuleAnswers with ChangeNotifier {
  List<ModuleAnswer> _moduleAnswers = [];

  List<ModuleAnswer> get moduleAnswers {
    return [..._moduleAnswers];
  }

  List<ModuleAnswer> findAnsByQueNum(int queNum) {
    return _moduleAnswers
        .where((answer) => answer.modQueNum == queNum)
        .toList();
  }

  Future<List<ModuleAnswer>> fetchAnswer(int modQuesNum) async {
    var parameters = {'modQuesNum': modQuesNum.toString()};
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/moduletest/getmoduleanswers.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<ModuleAnswer> moduleAnswer = [];
        for (var i = 0; i < extractedData.length; i++) {
          var answer = ModuleAnswer.fromJson(extractedData[i]);
          moduleAnswer.add(answer);
        }
        _moduleAnswers = moduleAnswer;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      // throw (error);
    }
    return _moduleAnswers;
  }
}
