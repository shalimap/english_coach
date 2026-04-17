import 'dart:convert';
import 'package:flutter/foundation.dart';

List<TopicMarksheet> topicMarksheetFromJson(String str) =>
    List<TopicMarksheet>.from(
        json.decode(str).map((x) => TopicMarksheet.fromJson(x)));

String topicMarksheetToJson(List<TopicMarksheet> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TopicMarksheet with ChangeNotifier {
  TopicMarksheet({
    this.topansId,
    this.ttestId,
    this.topicQueNum,
    this.topansAnswer,
  });

  int? topansId;
  int? ttestId;
  int? topicQueNum;
  String? topansAnswer;

  factory TopicMarksheet.fromJson(Map<String, dynamic> json) => TopicMarksheet(
        topansId: int.parse(json["topans_id"]),
        ttestId: int.parse(json["ttest_id"]),
        topicQueNum: int.parse(json["topic_que_num"]),
        topansAnswer: json["topans_answer"],
      );

  Map<String, dynamic> toJson() => {
        "topans_id": topansId,
        "ttest_id": ttestId,
        "topic_que_num": topicQueNum,
        "topans_answer": topansAnswer,
      };
}
