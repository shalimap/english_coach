import 'dart:convert';
import 'package:flutter/cupertino.dart';

List<AudioAnswer> audioAnswerFromJson(String str) => List<AudioAnswer>.from(
    json.decode(str).map((x) => AudioAnswer.fromJson(x)));

String audioAnswerToJson(List<AudioAnswer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AudioAnswer with ChangeNotifier {
  AudioAnswer({
    this.audAnsId,
    this.audQuesNum,
    this.audTextAnswer,
  });

  int? audAnsId;
  int? audQuesNum;
  String? audTextAnswer;

  factory AudioAnswer.fromJson(Map<String, dynamic> json) => AudioAnswer(
        audAnsId: int.parse(json["aud_ans_id"]),
        audQuesNum: int.parse(json["aud_ques_num"]),
        audTextAnswer: json["aud_text_answer"],
      );

  Map<String, dynamic> toJson() => {
        "aud_ans_id": audAnsId,
        "aud_num": audQuesNum,
        "aud_text_answer": audTextAnswer,
      };
}
