import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/topic_question.dart';

class TopicTestQuestion with ChangeNotifier {
  List<TopicQuestion> _topicQuestions = [];

  List<TopicQuestion> get topicQuestions {
    return [..._topicQuestions];
  }

  Future<List<TopicQuestion>> fetchQuestions(int topicId, int modId) async {
    var parameters = {
      'topicNum': topicId.toString(),
      'modId': modId.toString()
    };
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/topictest/getquestions.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<TopicQuestion> topicQuestions = [];
        for (var i = 0; i < extractedData.length; i++) {
          var question = TopicQuestion.fromJson(extractedData[i]);
          topicQuestions.add(question);
        }
        topicQuestions.sort((a, b) => a.topicQueNum!.compareTo(b.topicQueNum!));
        _topicQuestions = topicQuestions;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _topicQuestions;
  }

  List<TopicQuestion> randomQues() {
    var shuffled = _topicQuestions.toList()..shuffle();
    return shuffled;
  }

  List<TopicQuestion> totalTopicQuestions(int topic) {
    return _topicQuestions.where((ques) => ques.tNum == topic).toList();
  }

  TopicQuestion findById(int quesNum) {
    return _topicQuestions.firstWhere((ques) => ques.topicQueNum == quesNum);
  }
}
