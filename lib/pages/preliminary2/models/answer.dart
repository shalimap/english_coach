import 'dart:convert';
import 'package:flutter/cupertino.dart';

List<PrelimTransAnswer> prelimTransAnswerFromJson(String str) =>
    List<PrelimTransAnswer>.from(
        json.decode(str).map((x) => PrelimTransAnswer.fromJson(x)));

String prelimTransAnswerToJson(List<PrelimTransAnswer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PrelimTransAnswer with ChangeNotifier {
  PrelimTransAnswer({
    this.prelimTransId,
    this.prelimTransQuesNum,
    this.prelimTransAnswer,
  });

  int? prelimTransId;
  int? prelimTransQuesNum;
  String? prelimTransAnswer;

  factory PrelimTransAnswer.fromJson(Map<String, dynamic> json) =>
      PrelimTransAnswer(
        prelimTransId: int.parse(json["prelim_trans_id"]),
        prelimTransQuesNum: int.parse(json["prelim_trans_ques_num"]),
        prelimTransAnswer: json["prelim_trans_answer"],
      );

  Map<String, dynamic> toJson() => {
        "prelim_trans_id": prelimTransId,
        "prelim_trans_ques_num": prelimTransQuesNum,
        "prelim_trans_answer": prelimTransAnswer,
      };
}
