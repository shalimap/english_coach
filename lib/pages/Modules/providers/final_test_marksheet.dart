import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/final_marksheet.dart';

class FinaltestMarksheet with ChangeNotifier {
  List<FinalMarksheet> _marksheet = [];

  List<FinalMarksheet> get marksheet => [..._marksheet];

  Future<int> addNewMarksheet(FinalMarksheet marksheet) async {
    var markId;
    var parameters = {
      'finalTestId': marksheet.finalTestId.toString(),
      'finalquesNum': marksheet.finalQuesNumber.toString(),
      'finaluserAnswer': marksheet.finalUserAnswer,
    };
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/bin/finaltest/insertmarksheet.php');
    try {
      await http.post(uri, body: parameters).then((response) {
        final newMarksheet = FinalMarksheet(
          finalTestId: marksheet.finalTestId,
          finalQuesNumber: marksheet.finalQuesNumber,
          finalUserAnswer: marksheet.finalUserAnswer,
        );
        markId = int.parse(response.body);
        _marksheet.add(newMarksheet);
        notifyListeners();
      });
    } catch (error) {
      throw (error);
    }
    return markId;
  }

  Future<List<FinalMarksheet>> fetchMarksheet(int testId) async {
    var parameters = {'testId': testId.toString()};
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/bin/finaltest/getmarksheet.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /*  headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<FinalMarksheet> loadedMarksheet = [];
        for (var i = 0; i < extractedData.length; i++) {
          var marksheet = FinalMarksheet.fromJson(extractedData[i]);
          loadedMarksheet.add(marksheet);
        }
        loadedMarksheet
            .sort((a, b) => a.fmarksheetId!.compareTo(b.fmarksheetId!));
        _marksheet = loadedMarksheet;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _marksheet;
  }

  List<FinalMarksheet> findByTestId(int id) {
    return _marksheet.where((report) => report.finalTestId == id).toList();
  }
}
