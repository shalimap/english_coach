import 'dart:convert';

List<Mcqoptions> mcqoptionsFromJson(String str) =>
    List<Mcqoptions>.from(json.decode(str).map((x) => Mcqoptions.fromJson(x)));

String mcqoptionsToJson(List<Mcqoptions> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mcqoptions {
  Mcqoptions({
    this.prelimMcqId,
    this.prelimMcquesNum,
    this.prelimMcqAnswer,
  });

  int? prelimMcqId;
  int? prelimMcquesNum;
  String? prelimMcqAnswer;

  factory Mcqoptions.fromJson(Map<String, dynamic> json) => Mcqoptions(
        prelimMcqId: int.parse(json["prelim_mcq_id"]),
        prelimMcquesNum: int.parse(json["prelim_mcques_num"]),
        prelimMcqAnswer: json["prelim_mcq_answer"],
      );

  Map<String, dynamic> toJson() => {
        "prelim_mcq_id": prelimMcqId,
        "prelim_mcques_num": prelimMcquesNum,
        "prelim_mcq_answer": prelimMcqAnswer,
      };
}
