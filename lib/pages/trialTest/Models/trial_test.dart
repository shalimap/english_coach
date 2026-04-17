import 'dart:convert';

List<Trialtests> trialtestsFromJson(String str) =>
    List<Trialtests>.from(json.decode(str).map((x) => Trialtests.fromJson(x)));

String trialtestsToJson(List<Trialtests> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Trialtests {
  Trialtests({
    this.testId,
    this.modId,
    this.userId,
    this.mcqPoints,
    this.status,
  });

  int? testId;
  int? modId;
  int? userId;
  int? mcqPoints;
  int? status;

  factory Trialtests.fromJson(Map<String, dynamic> json) => Trialtests(
        testId: int.parse(json["test_id"]),
        modId: int.parse(json["mod_id"]),
        userId: int.parse(json["user_id"]),
        mcqPoints: int.parse(json["mcq_points"]),
        status: int.parse(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "test_id": testId,
        "mod_id": modId,
        "user_id": userId,
        "mcq_points": mcqPoints,
        "status": status,
      };
}
