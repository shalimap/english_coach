import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../models/tests.dart';

class ModuleTests with ChangeNotifier {
  List<Tests> _moduleTests = [];

  List<Tests> get moduleTests {
    return [..._moduleTests];
  }

  Future<List<Tests>> fetchTests(int modId, int userId) async {
    var parameters = {'modId': modId.toString(), 'userId': userId.toString()};
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/moduletest/moduletests.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Tests> moduleTest = [];
        for (var i = 0; i < extractedData.length; i++) {
          var tests = Tests.fromJson(extractedData[i]);
          moduleTest.add(tests);
        }
        moduleTest.sort((a, b) => a.mTestId!.compareTo(b.mTestId!));
        _moduleTests = moduleTest;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _moduleTests;
  }

  Tests findById(int id) {
    return _moduleTests.firstWhere((mod) => mod.modNum == id);
  }

  List<Tests> findByModId(int id) {
    return _moduleTests.where((mod) => mod.modNum == id).toList();
  }

  Future<int> addTest(Tests tests) async {
    var testId;
    var parameters = {
      'modId': tests.modNum.toString(),
      'userId': tests.userId.toString(),
    };
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/moduletest/inserttests.php', parameters);
    try {
      // const url =
      //     'https://api.englishcoach.app/api/dev/moduletest/inserttests.php';
      await http.post(uri).then((response) {
        final newTest = Tests(
          mTestId: int.parse(response.body),
          modNum: tests.modNum,
          userId: tests.userId,
          mTestPoints: 0,
          status: 0,
        );
        testId = int.parse(response.body);
        _moduleTests.add(newTest);
        notifyListeners();
      });
    } catch (error) {
      throw (error);
    }
    return testId;
  }

  Future<void> updateTest(int testId, int testPoints) async {
    var parameters = {
      'testId': testId.toString(),
      'testPoints': testPoints.toString(),
    };
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/moduletest/updatetests.php', parameters);
    // const url =
    //     'http://www.api.englishcoach.app/api/dev/moduletest/updatetests.php';
    await http.post(uri);
  }

  Future<void> deleteTest(int testId) async {
    var url = Uri.parse(
        'http://www.api.englishcoach.app/api/dev/moduletest/deletetest.php');
    await http.post(url, body: {
      'testId': testId.toString(),
    });
  }

  void removeTest(int testid) {
    _moduleTests.removeWhere((test) => test.mTestId == testid);
  }
}
