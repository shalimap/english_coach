import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../models/test.dart';

class PrelimTransTests with ChangeNotifier {
  List<PrelimTransTest> _transTests = [];

  List<PrelimTransTest> get transQuestions {
    return [..._transTests];
  }

  Future<void> updateTest(int testId, mcqPoints, transPoints) async {
    var parameters = {
      'testId': testId.toString(),
      'mcqPoints': mcqPoints.toString(),
      'transPoints': transPoints.toString(),
    };
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/exp/preliminary_2/updatetests.php');
    try {
      await http.post(uri, body: parameters);
    } catch (error) {
      throw (error);
    }
  }

  // Future<void> deleteTest(int testId) async {
  //   const url =
  //       'http://www.api.englishcoach.app/api/dev/____/deletetest.php';
  //   await http.post(url, body: {
  //     'testId': testId.toString(),
  //   });
  // }

  // void removeTest(int testid) {
  //   _transTests.removeWhere((test) => test.testId == testid);
  // }

  Future<void> setUserLevel(int userId, int mcqPoints, int transPoints) async {
    try {
      String level = (mcqPoints + transPoints) / 2 >= 9
          ? "b"
          : (mcqPoints + transPoints) / 2 >= 7
              ? "b"
              : "b";
      var parameters = {
        'userId': userId.toString(),
        'slLevel': level,
      };
      var uri = Uri.parse(
          'https://api.englishcoach.app/api/exp/level/insertlevel.php');
      await http.post(uri, body: parameters);
    } catch (error) {
      throw (error);
    }
  }
}
