import 'dart:convert';

import 'package:englishcoach/api/api.dart';
import 'package:flutter/material.dart';

import '../Models/mcq_marksheet.dart';
import 'package:http/http.dart' as http;

class McqAnswered with ChangeNotifier {
  List<Mcqmarksheet> _mcqanswered = [];

  List<Mcqmarksheet> get mcqanswered => [..._mcqanswered];

  Future<int> addNewMarksheet(Mcqmarksheet marksheet) async {
    var parameters = {
      'testId': marksheet.testId.toString(),
      'userId': marksheet.userId.toString(),
      'mcqQueNum': marksheet.prelimMcquesNum.toString(),
      'mcqAnswer': marksheet.prelimAns.toString(),
    };
    var uri = Uri.parse(Api.insertmcqmarksheet);
    var markId;
    try {
      await http.post(uri, body: parameters).then((response) {
        final newMarksheet = Mcqmarksheet(
          prelimAnsId: int.parse(response.body),
          testId: marksheet.testId,
          userId: marksheet.userId,
          prelimMcquesNum: marksheet.prelimMcquesNum,
          prelimAns: marksheet.prelimAns,
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

  Future<List<Mcqmarksheet>> fetchMarksheet(int testId) async {
    var parameters = {'testId': testId.toString()};

    var uri = Uri.parse(Api.baseUrl +
        'exp/preliminary_1/getmcqmarksheet.php?testId=${testId.toString()}');

    /*  var uri = Uri.https('www.api.englishcoach.app',
        '/api/exp/preliminary_2/getmcqmarksheet.php', parameters);
         Map<String, String> headers = {"Content-Type": "application/json"};
    */

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Mcqmarksheet> mcqMarksheets = [];
        for (var i = 0; i < extractedData.length; i++) {
          var marksheet = Mcqmarksheet.fromJson(extractedData[i]);
          mcqMarksheets.add(marksheet);
        }
        _mcqanswered = mcqMarksheets;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR-PRELIM1 : ' + error.toString());
      throw (error);
    }
    return _mcqanswered;
  }

  List<Mcqmarksheet> findByTestId(int id) {
    return _mcqanswered.where((report) => report.testId == id).toList();
  }
}
