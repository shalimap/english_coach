import 'dart:convert';

List<Mcqtests> mcqtestsFromJson(String str) =>
    List<Mcqtests>.from(json.decode(str).map((x) => Mcqtests.fromJson(x)));

String mcqtestsToJson(List<Mcqtests> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mcqtests {
  Mcqtests({
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

  factory Mcqtests.fromJson(Map<String, dynamic> json) => Mcqtests(
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
