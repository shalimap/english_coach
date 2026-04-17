import 'dart:convert';

List<Finalquestion> finalquestionFromJson(String str) =>
    List<Finalquestion>.from(
        json.decode(str).map((x) => Finalquestion.fromJson(x)));

String finalquestionToJson(List<Finalquestion> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Finalquestion {
  Finalquestion({
    this.finalQuesNumber,
    this.finalQuestions,
  });

  int? finalQuesNumber;
  String? finalQuestions;

  factory Finalquestion.fromJson(Map<String, dynamic> json) => Finalquestion(
        finalQuesNumber: int.parse(json["final_ques_number"]),
        finalQuestions: json["final_questions"],
      );

  Map<String, dynamic> toJson() => {
        "final_ques_number": finalQuesNumber,
        "final_questions": finalQuestions,
      };
}
