import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<PrelimTransTest> prelimTransTestFromJson(String str) =>
    List<PrelimTransTest>.from(
        json.decode(str).map((x) => PrelimTransTest.fromJson(x)));

String prelimTransTestToJson(List<PrelimTransTest> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PrelimTransTest with ChangeNotifier {
  PrelimTransTest({
    this.testId,
    this.userId,
    this.mcqPoints,
    this.transPoints,
    this.status,
  });

  int? testId;
  int? userId;
  int? mcqPoints;
  int? transPoints;
  int? status;

  factory PrelimTransTest.fromJson(Map<String, dynamic> json) =>
      PrelimTransTest(
        testId: int.parse(json["test_id"]),
        userId: int.parse(json["user_id"]),
        mcqPoints: int.parse(json["mcq_points"]),
        transPoints: int.parse(json["trans_points"]),
        status: int.parse(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "test_id": testId,
        "user_id": userId,
        "mcq_points": mcqPoints,
        "trans_points": transPoints,
        "status": status,
      };
}
