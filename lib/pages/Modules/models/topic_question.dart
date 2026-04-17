import 'dart:convert';
import 'package:flutter/foundation.dart';

List<TopicQuestion> topicFromJson(String str) => List<TopicQuestion>.from(
    json.decode(str).map((x) => TopicQuestion.fromJson(x)));

String topicToJson(List<TopicQuestion> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TopicQuestion with ChangeNotifier {
  TopicQuestion({
    this.topicQueNum,
    this.modId,
    this.tNum,
    this.topicQueQuestion,
  });

  int? topicQueNum;
  int? modId;
  int? tNum;
  String? topicQueQuestion;

  factory TopicQuestion.fromJson(Map<String, dynamic> json) => TopicQuestion(
        topicQueNum: int.parse(json["topic_que_num"]),
        modId: int.parse(json["mod_id"]),
        tNum: int.parse(json["t_num"]),
        topicQueQuestion: json["topic_que_question"],
      );

  Map<String, dynamic> toJson() => {
        "topic_que_num": topicQueNum,
        "mod_id": modId,
        "t_num": tNum,
        "topic_que_question": topicQueQuestion,
      };
}
