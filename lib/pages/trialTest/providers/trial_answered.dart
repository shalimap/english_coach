import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/trial_marksheet.dart';

class TrialAnswered with ChangeNotifier {
  List<Trialmarksheet> _mcqanswered = [];

  List<Trialmarksheet> get mcqanswered => [..._mcqanswered];

  Future<int> addNewMarksheet(Trialmarksheet marksheet) async {
    var markId;
    try {
      var url = Uri.parse(
          'https://api.englishcoach.app/api/bin/trialtest/insertmcqmarksheet.php');
      await http.post(url, body: {
        'testId': marksheet.testId.toString(),
        'userId': marksheet.userId.toString(),
        'mcqQueNum': marksheet.trailMcqNum.toString(),
        'mcqAnswer': marksheet.trialAns.toString(),
      }).then((response) {
        final newMarksheet = Trialmarksheet(
          trialAnsId: int.parse(response.body),
          testId: marksheet.testId,
          userId: marksheet.userId,
          trailMcqNum: marksheet.trailMcqNum,
          trialAns: marksheet.trialAns,
        );
        markId = int.parse(response.body);
        _mcqanswered.add(newMarksheet);
        notifyListeners();
      });
    } catch (error) {
      throw (error);
    }
    return markId;
  }

  Future<List<Trialmarksheet>> fetchMarksheet(int testId) async {
    var parameters = {'testId': testId.toString()};
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/bin/trialtest/getmcqmarksheet.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Trialmarksheet> mcqMarksheets = [];
        for (var i = 0; i < extractedData.length; i++) {
          var marksheet = Trialmarksheet.fromJson(extractedData[i]);
          mcqMarksheets.add(marksheet);
        }
        _mcqanswered = mcqMarksheets;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _mcqanswered;
  }

  List<Trialmarksheet> findByTestId(int id) {
    return _mcqanswered.where((report) => report.testId == id).toList();
  }
}
