import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/topic_marksheet.dart';

class TopicTestMarksheet with ChangeNotifier {
  List<TopicMarksheet> _topicMarksheet = [];

  List<TopicMarksheet> get topicMarksheet {
    return [..._topicMarksheet];
  }

  Future<List<TopicMarksheet>> fetchMarksheet(int testId) async {
    var parameters = {'testId': testId.toString()};
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/topictest/getmarksheet.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /*  headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<TopicMarksheet> topicMarksheets = [];
        for (var i = 0; i < extractedData.length; i++) {
          var marksheet = TopicMarksheet.fromJson(extractedData[i]);
          topicMarksheets.add(marksheet);
        }
        topicMarksheet.sort((a, b) => a.topansId!.compareTo(b.topansId!));
        _topicMarksheet = topicMarksheets;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _topicMarksheet;
  }

  TopicMarksheet findByAnsId(int id) {
    return _topicMarksheet.firstWhere((report) => report.topansId == id);
  }

  TopicMarksheet findById(int id) {
    return _topicMarksheet.firstWhere((report) => report.ttestId == id);
  }

  List<TopicMarksheet> findByTestId(int id) {
    return _topicMarksheet.where((report) => report.ttestId == id).toList();
  }

  Future<int> addNewMarksheet(TopicMarksheet marksheet) async {
    var markId;
    var parameters = {
      'testId': marksheet.ttestId.toString(),
      'topicQueNum': marksheet.topicQueNum.toString(),
      'topicAnswer': marksheet.topansAnswer,
    };
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/dev/topictest/insertmarksheet.php');
    try {
      await http.post(uri, body: parameters).then((response) {
        final newMarksheet = TopicMarksheet(
          topansId: int.parse(response.body),
          ttestId: marksheet.ttestId,
          topicQueNum: marksheet.topicQueNum,
          topansAnswer: marksheet.topansAnswer,
        );
        markId = int.parse(response.body);
        _topicMarksheet.add(newMarksheet);
        notifyListeners();
      });
    } catch (error) {
      throw (error);
    }
    return markId;
  }
}
