import 'dart:convert';

List<Finaltests> finaltestsFromJson(String str) =>
    List<Finaltests>.from(json.decode(str).map((x) => Finaltests.fromJson(x)));

String finaltestsToJson(List<Finaltests> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Finaltests {
  Finaltests({
    this.finalTestId,
    this.userId,
    this.finalTestPoints,
    this.finalStatus,
  });

  int? finalTestId;
  int? userId;
  int? finalTestPoints;
  int? finalStatus;

  factory Finaltests.fromJson(Map<String, dynamic> json) => Finaltests(
        finalTestId: int.parse(json["final_test_id"]),
        userId: int.parse(json["user_id"]),
        finalTestPoints: int.parse(json["final_test_points"]),
        finalStatus: int.parse(json["final_status"]),
      );

  Map<String, dynamic> toJson() => {
        "final_test_id": finalTestId,
        "user_id": userId,
        "final_test_points": finalTestPoints,
        "final_status": finalStatus,
      };
}
