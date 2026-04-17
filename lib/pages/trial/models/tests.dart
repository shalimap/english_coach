import 'package:flutter/material.dart';
import 'dart:convert';

List<Tests> testsFromJson(String str) =>
    List<Tests>.from(json.decode(str).map((x) => Tests.fromJson(x)));

String testsToJson(List<Tests> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tests with ChangeNotifier {
  Tests({
    this.mTestId,
    this.modNum,
    this.userId,
    this.mTestPoints,
    this.status,
  });

  int? mTestId;
  int? modNum;
  int? userId;
  int? mTestPoints;
  int? status;

  factory Tests.fromJson(Map<String, dynamic> json) => Tests(
        mTestId: int.parse(json["mtest_id"]),
        modNum: int.parse(json["mod_num"]),
        userId: int.parse(json["user_id"]),
        mTestPoints: int.parse(json["mtest_points"]),
        status: int.parse(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "mtest_id": mTestId,
        "mod_num": modNum,
        "user_id": userId,
        "mtest_points": mTestPoints,
        "status": status,
      };
}
