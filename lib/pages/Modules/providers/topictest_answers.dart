import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/topic_answer.dart';

class TopicTestAnswer with ChangeNotifier {
  List<TopicAnswer> _topicAnswer = [];

  List<TopicAnswer> get topicAnswers {
    return [..._topicAnswer];
  }

  List<TopicAnswer> findAnsByQueNum(int queNum) {
    return _topicAnswer
        .where((answer) => answer.topicQueNum == queNum)
        .toList();
  }

  Future<List<TopicAnswer>> fetchAnswer(int topicQuesNum) async {
    var parameters = {'topicQuesNum': topicQuesNum.toString()};
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/topictest/getanswer.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<TopicAnswer> topicAnswers = [];
        for (var i = 0; i < extractedData.length; i++) {
          var answer = TopicAnswer.fromJson(extractedData[i]);
          topicAnswers.add(answer);
        }
        //  _topicAnswer.clear();
        _topicAnswer = topicAnswers;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      // throw (error);
    }
    return _topicAnswer;
  }
}
