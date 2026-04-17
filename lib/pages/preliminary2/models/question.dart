import 'dart:convert';
import 'package:flutter/cupertino.dart';

List<PrelimTransQuestion> prelimTransQuestionFromJson(String str) =>
    List<PrelimTransQuestion>.from(
        json.decode(str).map((x) => PrelimTransQuestion.fromJson(x)));

String prelimTransQuestionToJson(List<PrelimTransQuestion> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PrelimTransQuestion with ChangeNotifier {
  PrelimTransQuestion({
    this.prelimTransQuesNum,
    this.tNum,
    this.prelimTransQuestion,
  });

  int? prelimTransQuesNum;
  int? tNum;
  String? prelimTransQuestion;

  factory PrelimTransQuestion.fromJson(Map<String, dynamic> json) =>
      PrelimTransQuestion(
        prelimTransQuesNum: int.parse(json["prelim_trans_ques_num"]),
        tNum: int.parse(json["t_num"]),
        prelimTransQuestion: json["prelim_trans_question"],
      );

  Map<String, dynamic> toJson() => {
        "prelim_trans_ques_num": prelimTransQuesNum,
        "t_num": tNum,
        "prelim_trans_question": prelimTransQuestion,
      };
}
