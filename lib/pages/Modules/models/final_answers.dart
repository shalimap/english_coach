import 'dart:convert';

List<Finalanswer> finalanswerFromJson(String str) => List<Finalanswer>.from(
    json.decode(str).map((x) => Finalanswer.fromJson(x)));

String finalanswerToJson(List<Finalanswer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Finalanswer {
  Finalanswer({
    this.finalAnsId,
    this.finalQuesNumber,
    this.finalAnswers,
  });

  int? finalAnsId;
  int? finalQuesNumber;
  String? finalAnswers;

  factory Finalanswer.fromJson(Map<String, dynamic> json) => Finalanswer(
        finalAnsId: int.parse(json["final_ans_id"]),
        finalQuesNumber: int.parse(json["final_ques_number"]),
        finalAnswers: json["final_answers"],
      );

  Map<String, dynamic> toJson() => {
        "final_ans_id": finalAnsId,
        "final_ques_number": finalQuesNumber,
        "final_answers": finalAnswers,
      };
}
