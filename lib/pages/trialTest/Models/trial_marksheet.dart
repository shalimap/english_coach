import 'dart:convert';

List<Trialmarksheet> trialmarksheetFromJson(String str) =>
    List<Trialmarksheet>.from(
        json.decode(str).map((x) => Trialmarksheet.fromJson(x)));

String trialmarksheetToJson(List<Trialmarksheet> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Trialmarksheet {
  Trialmarksheet({
    this.trialAnsId,
    this.userId,
    this.testId,
    this.trailMcqNum,
    this.trialAns,
  });

  int? trialAnsId;
  int? userId;
  int? testId;
  int? trailMcqNum;
  int? trialAns;

  factory Trialmarksheet.fromJson(Map<String, dynamic> json) => Trialmarksheet(
        trialAnsId: int.parse(json["trial_ans_id"]),
        userId: int.parse(json["user_id"]),
        testId: int.parse(json["test_id"]),
        trailMcqNum: int.parse(json["trail_mcq_num"]),
        trialAns: int.parse(json["trial_ans"]),
      );

  Map<String, dynamic> toJson() => {
        "trial_ans_id": trialAnsId,
        "user_id": userId,
        "test_id": testId,
        "trail_mcq_num": trailMcqNum,
        "trial_ans": trialAns,
      };
}
