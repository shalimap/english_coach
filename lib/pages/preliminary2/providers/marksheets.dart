import 'package:englishcoach/api/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/marksheet.dart';

class PrelimTransMarksheets with ChangeNotifier {
  List<PrelimTransMarksheet> _transMarksheet = [];

  List<PrelimTransMarksheet> get transMarksheet {
    return [..._transMarksheet];
  }

  Future<List<PrelimTransMarksheet>> fetchMarksheet(int testId) async {
    var parameters = {'testId': testId.toString()};

    var uri = Uri.parse(Api.baseUrl +
        'exp/preliminary_2/getmarksheet.php?testId=${testId.toString()}');
    /* var uri = Uri.https('www.api.englishcoach.app',
        '/api/exp/preliminary_2/getmarksheet.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"}; */
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<PrelimTransMarksheet> transMarksheets = [];
        for (var i = 0; i < extractedData.length; i++) {
          var marksheet = PrelimTransMarksheet.fromJson(extractedData[i]);
          transMarksheets.add(marksheet);
        }
        _transMarksheet = transMarksheets;
        notifyListeners();
      }
    } catch (error) {
      print('ERRORM : ' + error.toString());
      throw (error);
    }
    return _transMarksheet;
  }

  PrelimTransMarksheet findByAnsId(int id) {
    return _transMarksheet
        .firstWhere((report) => report.prelimTransAnsId == id);
  }

  PrelimTransMarksheet findById(int id) {
    return _transMarksheet.firstWhere((report) => report.testId == id);
  }

  List<PrelimTransMarksheet> findByTestId(int id) {
    return _transMarksheet.where((report) => report.testId == id).toList();
  }

  Future<int> addNewMarksheet(PrelimTransMarksheet marksheet) async {
    var parameters = {
      'testId': marksheet.testId.toString(),
      'userId': marksheet.userId.toString(),
      'transQueNum': marksheet.prelimTransQuesNum.toString(),
      'transAnswer': marksheet.prelimTransAnswered,
    };
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/exp/preliminary_2/insertmarksheet.php');
    var markId;
    try {
      await http.post(uri, body: parameters).then((response) {
        final newMarksheet = PrelimTransMarksheet(
          prelimTransAnsId: int.parse(response.body),
          testId: marksheet.testId,
          userId: marksheet.userId,
          prelimTransQuesNum: marksheet.prelimTransQuesNum,
          prelimTransAnswered: marksheet.prelimTransAnswered,
        );
        markId = int.parse(response.body);
        _transMarksheet.add(newMarksheet);
        notifyListeners();
      });
    } catch (error) {
      throw (error);
    }
    return markId;
  }
}
