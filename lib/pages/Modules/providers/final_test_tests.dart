import '../models/final_test.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FinalTestChecks with ChangeNotifier {
  List<Finaltests> _finaltests = [];

  List<Finaltests> get finaltests => [..._finaltests];

  Future<List<Finaltests>> fetchTests(int userId) async {
    var parameters = {'userId': userId.toString()};
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/bin/finaltest/getfinaltests.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Finaltests> finalTest = [];
        for (var i = 0; i < extractedData.length; i++) {
          var tests = Finaltests.fromJson(extractedData[i]);
          finalTest.add(tests);
        }
        finalTest.sort((a, b) => a.finalTestId!.compareTo(b.finalTestId!));
        _finaltests = finalTest;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _finaltests;
  }

  List<Finaltests> findByUsrId(int id) {
    return _finaltests.where((mod) => mod.userId == id).toList();
  }

  Future<int> addTest(Finaltests tests) async {
    var testId;
    var parameters = {
      'userId': tests.userId.toString(),
    };
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/bin/finaltest/insertfinaltest.php');
    try {
      await http.post(uri, body: parameters).then((response) {
        final newTest = Finaltests(
          userId: tests.userId,
          finalTestPoints: 0,
          finalStatus: 0,
        );
        testId = int.parse(response.body);
        _finaltests.add(newTest);
        notifyListeners();
      });
    } catch (error) {
      throw (error);
    }
    return testId;
  }

  Future<void> updateTest(int testId, int testPoints) async {
    var parameters = {
      'finaltestId': testId.toString(),
      'finaltestPoints': testPoints.toString(),
    };
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/bin/finaltest/updatetests.php');
    try {
      await http.post(uri, body: parameters);
    } catch (error) {
      throw (error);
    }
  }
}
