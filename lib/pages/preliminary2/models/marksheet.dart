import 'dart:convert';
import 'package:flutter/cupertino.dart';

List<PrelimTransMarksheet> prelimTransMarksheetFromJson(String str) =>
    List<PrelimTransMarksheet>.from(
        json.decode(str).map((x) => PrelimTransMarksheet.fromJson(x)));

String prelimTransMarksheetToJson(List<PrelimTransMarksheet> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PrelimTransMarksheet with ChangeNotifier {
  PrelimTransMarksheet({
    this.prelimTransAnsId,
    this.userId,
    this.testId,
    this.prelimTransQuesNum,
    this.prelimTransAnswered,
  });

  int? prelimTransAnsId;
  int? userId;
  int? testId;
  int? prelimTransQuesNum;
  String? prelimTransAnswered;

  factory PrelimTransMarksheet.fromJson(Map<String, dynamic> json) =>
      PrelimTransMarksheet(
        prelimTransAnsId: int.parse(json["prelim_trans_ans_id"]),
        userId: int.parse(json["user_id"]),
        testId: int.parse(json["test_id"]),
        prelimTransQuesNum: int.parse(json["prelim_trans_ques_num"]),
        prelimTransAnswered: json["prelim_trans_answered"],
      );

  Map<String, dynamic> toJson() => {
        "prelim_trans_ans_id": prelimTransAnsId,
        "user_id": userId,
        "test_id": testId,
        "prelim_trans_ques_num": prelimTransQuesNum,
        "prelim_trans_answered": prelimTransAnswered,
      };
}
