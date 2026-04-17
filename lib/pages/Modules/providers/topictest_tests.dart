import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/topic_test.dart';

class TopicTests with ChangeNotifier {
  List<TopicTest> _topicTests = [];

  List<TopicTest> get topicQuestions {
    return [..._topicTests];
  }

  Future<List<TopicTest>> fetchTests(int modId, int userId) async {
    var parameters = {'modId': modId.toString(), 'userId': userId.toString()};
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/topictest/gettests.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /*  headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<TopicTest> tests = [];
        for (var i = 0; i < extractedData.length; i++) {
          var test = TopicTest.fromJson(extractedData[i]);
          tests.add(test);
        }
        tests.sort((a, b) => a.ttestId!.compareTo(b.ttestId!));
        _topicTests = tests;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _topicTests;
  }

  TopicTest findById(int id) {
    return _topicTests.firstWhere((topic) => topic.ttestId == id);
  }

  List<TopicTest> findByTopicId(int id) {
    return _topicTests.where((topic) => topic.tNum == id).toList();
  }

  Future<int> addTest(TopicTest tests) async {
    var testId;
    var parameters = {
      'tNum': tests.tNum.toString(),
      'modId': tests.modId.toString(),
      'userId': tests.userId.toString(),
    };
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/dev/topictest/inserttests.php');
    try {
      await http.post(uri, body: parameters).then((response) {
        final newTest = TopicTest(
          ttestId: int.parse(response.body),
          tNum: tests.tNum,
          modId: tests.modId,
          userId: tests.userId,
          ttestPoints: 0,
          status: 0,
        );
        testId = int.parse(response.body);
        _topicTests.add(newTest);
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
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/dev/topictest/updatetests.php');
    try {
      await http.post(uri, body: parameters);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> deleteTest(int testId) async {
    var parameters = {
      'testId': testId.toString(),
    };
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/dev/topictest/deletetest.php');
    try {
      await http.post(uri, body: parameters);
    } catch (error) {
      throw (error);
    }
  }

  void removeTest(int testid) {
    _topicTests.removeWhere((test) => test.ttestId == testid);
  }
}
