import 'package:englishcoach/api/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../models/marksheet.dart';

class ModuleMarkSheet with ChangeNotifier {
  List<Marksheet> _moduleMarksheet = [];

  List<Marksheet> get moduleMarksheet {
    return [..._moduleMarksheet];
  }

  Future<List<Marksheet>> fetchMarksheet(int testId) async {
    var parameters = {'mTestId': testId.toString()};

    var uri = Uri.parse(Api.baseUrl +
        'dev/moduletest/getmarksheet.php?mTestId=${testId.toString()}');
    // var uri = Uri.https('www.api.englishcoach.app',
    //     '/api/dev/moduletest/getmarksheet.php', parameters);
    // Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Marksheet> loadedMarksheet = [];
        for (var i = 0; i < extractedData.length; i++) {
          var marksheet = Marksheet.fromJson(extractedData[i]);
          loadedMarksheet.add(marksheet);
        }
        loadedMarksheet.sort((a, b) => a.mMarkId!.compareTo(b.mMarkId!));
        _moduleMarksheet = loadedMarksheet;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _moduleMarksheet;
  }

  Marksheet findById(int id) {
    return _moduleMarksheet.firstWhere((report) => report.mTestId == id);
  }

  List<Marksheet> findByTestId(int id) {
    return _moduleMarksheet.where((report) => report.mTestId == id).toList();
  }

  Future<int> addNewMarksheet(Marksheet marksheet) async {
    var markId;
    var parameters = {
      'mTestId': marksheet.mTestId.toString(),
      'exeNum': marksheet.exeNum.toString(),
      'mMarkAnswer': marksheet.mMarkAnswer,
    };
    // var uri = Uri.https('www.api.englishcoach.app',
    //     '/api/dev/moduletest/insertmarksheet.php', parameters);

    var uri = Uri.parse(Api.baseUrl + 'dev/moduletest/insertmarksheet.php');

    try {
      // const url =
      //     'https://api.englishcoach.app/api/dev/moduletest/insertmarksheet.php';
      await http.post(uri, body: parameters).then((response) {
        final newMarksheet = Marksheet(
          mMarkId: int.parse(response.body),
          mTestId: marksheet.mTestId,
          exeNum: marksheet.exeNum,
          mMarkAnswer: marksheet.mMarkAnswer,
        );
        markId = int.parse(response.body);
        _moduleMarksheet.add(newMarksheet);
        notifyListeners();
      });
    } catch (error) {
      throw (error);
    }
    return markId;
  }
}
