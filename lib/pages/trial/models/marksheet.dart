import 'package:flutter/foundation.dart';
import 'dart:convert';

List<Marksheet> marksheetFromJson(String str) =>
    List<Marksheet>.from(json.decode(str).map((x) => Marksheet.fromJson(x)));

String marksheetToJson(List<Marksheet> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Marksheet with ChangeNotifier {
  Marksheet({
    this.mMarkId,
    this.mTestId,
    this.exeNum,
    this.mMarkAnswer,
  });

  int? mMarkId;
  int? mTestId;
  int? exeNum;
  String? mMarkAnswer;

  factory Marksheet.fromJson(Map<String, dynamic> json) => Marksheet(
        mMarkId: int.parse(json["mmark_id"]),
        mTestId: int.parse(json["mtest_id"]),
        exeNum: int.parse(json["exe_num"]),
        mMarkAnswer: json["mmark_answer"],
      );

  Map<String, dynamic> toJson() => {
        "mmark_id": mMarkId,
        "mtest_id": mTestId,
        "exe_num": exeNum,
        "mmark_answer": mMarkAnswer,
      };
}
