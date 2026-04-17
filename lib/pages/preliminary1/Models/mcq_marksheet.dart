import 'dart:convert';

List<Mcqmarksheet> mcqmarksheetFromJson(String str) => List<Mcqmarksheet>.from(
    json.decode(str).map((x) => Mcqmarksheet.fromJson(x)));

String mcqmarksheetToJson(List<Mcqmarksheet> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mcqmarksheet {
  Mcqmarksheet({
    this.prelimAnsId,
    this.userId,
    this.testId,
    this.prelimMcquesNum,
    this.prelimAns,
  });

  int? prelimAnsId;
  int? userId;
  int? testId;
  int? prelimMcquesNum;
  int? prelimAns;

  factory Mcqmarksheet.fromJson(Map<String, dynamic> json) => Mcqmarksheet(
        prelimAnsId: int.parse(json["prelim_ans_id"]),
        userId: int.parse(json["user_id"]),
        testId: int.parse(json["test_id"]),
        prelimMcquesNum: int.parse(json["prelim_mcques_num"]),
        prelimAns: int.parse(json["prelim_ans"]),
      );

  Map<String, dynamic> toJson() => {
        "prelim_ans_id": prelimAnsId,
        "user_id": userId,
        "test_id": testId,
        "prelim_mcques_num": prelimMcquesNum,
        "prelim_ans": prelimAns,
      };
}
