import 'dart:convert';
import 'package:flutter/foundation.dart';

List<TopicTest> topicTestFromJson(String str) =>
    List<TopicTest>.from(json.decode(str).map((x) => TopicTest.fromJson(x)));

String topicTestToJson(List<TopicTest> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TopicTest with ChangeNotifier {
  TopicTest({
    this.ttestId,
    this.tNum,
    this.modId,
    this.userId,
    this.ttestPoints,
    this.status,
  });

  int? ttestId;
  int? tNum;
  int? modId;
  int? userId;
  int? ttestPoints;
  int? status;

  factory TopicTest.fromJson(Map<String, dynamic> json) => TopicTest(
        ttestId: int.parse(json["ttest_id"]),
        tNum: int.parse(json["t_num"]),
        modId: int.parse(json["mod_id"]),
        userId: int.parse(json["user_id"]),
        ttestPoints: int.parse(json["ttest_points"]),
        status: int.parse(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "ttest_id": ttestId,
        "t_num": tNum,
        "mod_id": modId,
        "user_id": userId,
        "ttest_points": ttestPoints,
        "status": status,
      };
}
