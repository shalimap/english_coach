import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/trial_test.dart';
import 'dart:convert';

class TrialTest with ChangeNotifier {
  List<Trialtests> _trialtest = [];

  List<Trialtests> get trialtest => [..._trialtest];

  Future<List<Trialtests>> fetchTests(int modId, int userId) async {
    var parameters = {'modId': modId.toString(), 'userId': userId.toString()};
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/bin/trialtest/gettrialtest.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Trialtests> trialTest = [];
        for (var i = 0; i < extractedData.length; i++) {
          var tests = Trialtests.fromJson(extractedData[i]);
          trialTest.add(tests);
        }
        trialTest.sort((a, b) => a.testId!.compareTo(b.testId!));
        _trialtest = trialTest;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _trialtest;
  }

  List<Trialtests> findByUsrId(int id) {
    return _trialtest.where((mod) => mod.userId == id).toList();
  }

  Future<int> addTest(Trialtests tests) async {
    var testId;
    try {
      var url = Uri.parse(
          'https://api.englishcoach.app/api/bin/trialtest/insertfinaltest.php');
      await http.post(url, body: {
        'modId': tests.modId.toString(),
        'userId': tests.userId.toString(),
      }).then((response) {
        final newTest = Trialtests(
          testId: tests.testId,
          modId: tests.modId,
          userId: tests.userId,
          mcqPoints: 0,
          status: 0,
        );
        testId = int.parse(response.body);
        _trialtest.add(newTest);
        notifyListeners();
      });
    } catch (error) {
      throw (error);
    }
    return testId;
  }

  Future<void> updateTest(int testId, int testPoints) async {
    // try {
    var url = Uri.parse(
        'http://www.api.englishcoach.app/api/bin/trialtest/updatetests.php');
    await http.post(url, body: {
      'trialtestId': testId.toString(),
      'trialtestPoints': testPoints.toString(),
    });
  }
}
