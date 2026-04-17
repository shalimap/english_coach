import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<AudioTest> audioTestFromJson(String str) =>
    List<AudioTest>.from(json.decode(str).map((x) => AudioTest.fromJson(x)));

String audioTestToJson(List<AudioTest> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AudioTest with ChangeNotifier {
  AudioTest({
    this.audTestId,
    this.audNum,
    this.audQuesNum,
    this.userId,
    this.score,
    this.status,
  });

  int? audTestId;
  int? audNum;
  int? audQuesNum;
  int? userId;
  int? score;
  int? status;

  factory AudioTest.fromJson(Map<String, dynamic> json) => AudioTest(
        audTestId: int.parse(json["aud_test_id"]),
        audNum: int.parse(json["aud_num"]),
        audQuesNum: int.parse(json["aud_ques_num"]),
        userId: int.parse(json["user_id"]),
        score: int.parse(json["score"]),
        status: int.parse(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "aud_test_id": audTestId,
        "aud_num": audNum,
        "aud_ques_num": audQuesNum,
        "user_id": userId,
        "score": score,
        "status": status,
      };
}
