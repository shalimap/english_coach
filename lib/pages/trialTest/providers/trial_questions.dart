import 'package:flutter/material.dart';
import '../Models/trial_question.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrialQuestion with ChangeNotifier {
  List<Trialquestions> _trialquestions = [];

  List<Trialquestions> get trialquestions => [..._trialquestions];

  Future<List<Trialquestions>> fetchQuestions(modid) async {
    var parameter = {'modId': modid.toString()};
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/bin/trialtest/getquestions.php', parameter);
    Map<String, String> headers = {"Content-Type": "application/json"};

    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);

        List<Trialquestions> trialmcqOptions = [];

        for (var i = 0; i < extractedData.length; i++) {
          var options = Trialquestions.fromJson(extractedData[i]);

          trialmcqOptions.add(options);
        }
        trialmcqOptions
            .sort((a, b) => a.trailMcqNum!.compareTo(b.trailMcqNum!));

        _trialquestions = trialmcqOptions;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _trialquestions;
  }

  List<Trialquestions> randomQues() {
    var shuffled = _trialquestions.toList()..shuffle();
    return shuffled;
  }

  Trialquestions findQuestions(int exe) {
    return _trialquestions.firstWhere((que) => que.trailMcqNum == exe);
  }
}
