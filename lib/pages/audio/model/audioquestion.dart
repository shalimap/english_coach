import 'dart:convert';
import 'package:flutter/cupertino.dart';

List<AudioQuestion> audioQuestionFromJson(String str) =>
    List<AudioQuestion>.from(
        json.decode(str).map((x) => AudioQuestion.fromJson(x)));

String audioQuestionToJson(List<AudioQuestion> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AudioQuestion with ChangeNotifier {
  AudioQuestion({
    this.audQuesNum,
    this.audNum,
    this.audUrl,
  });

  int? audQuesNum;
  int? audNum;
  String? audUrl;

  factory AudioQuestion.fromJson(Map<String, dynamic> json) => AudioQuestion(
        audQuesNum: int.parse(json["aud_ques_num"]),
        audNum: int.parse(json["aud_num"]),
        audUrl: json["aud_url"],
      );

  Map<String, dynamic> toJson() => {
        "aud_ques_num": audQuesNum,
        "aud_num": audNum,
        "aud_url": audUrl,
      };
}
