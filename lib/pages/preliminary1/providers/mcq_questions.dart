import 'package:englishcoach/api/api.dart';
import 'package:flutter/material.dart';
import '../Models/mcq_question.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class McqQuestion with ChangeNotifier {
  List<Mcqquestions> _mcqquestions = [];

  List<Mcqquestions> get mcqquestions => [..._mcqquestions];

  Future<List<Mcqquestions>> fetchQuestions() async {
    var uri = Uri.parse(Api.baseUrl + 'exp/preliminary_1/getquestions.php');
    /*  var uri = Uri.https(
      'www.api.englishcoach.app',
      '/api/exp/preliminary_1/getquestions.php',
    );
    */
    //Map<String, String> headers = {"Content-Type": "application/json"};

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Mcqquestions> mcqQuestions = [];

        for (var i = 0; i < extractedData.length; i++) {
          var question = Mcqquestions.fromJson(extractedData[i]);

          mcqQuestions.add(question);
        }
        mcqQuestions
            .sort((a, b) => a.prelimMcquesNum!.compareTo(b.prelimMcquesNum!));

        _mcqquestions = mcqQuestions;
        notifyListeners();
      }
    } catch (error) {
      print('ERRORQ : ' + error.toString());
      throw (error);
    }
    return _mcqquestions;
  }

  List<Mcqquestions> randomQues() {
    var shuffled = _mcqquestions.toList()..shuffle();
    return shuffled;
  }

  Mcqquestions findQuestions(int exe) {
    return _mcqquestions.firstWhere((que) => que.prelimMcquesNum == exe);
  }
}
