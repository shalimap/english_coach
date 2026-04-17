import 'dart:convert';

List<Mcqquestions> mcqquestionsFromJson(String str) => List<Mcqquestions>.from(
    json.decode(str).map((x) => Mcqquestions.fromJson(x)));

String mcqquestionsToJson(List<Mcqquestions> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mcqquestions {
  Mcqquestions({
    this.prelimMcquesNum,
    this.tNum,
    this.prelimMcquesQuestion,
    this.prelimMcqId,
  });

  int? prelimMcquesNum;
  int? tNum;
  String? prelimMcquesQuestion;
  int? prelimMcqId;

  factory Mcqquestions.fromJson(Map<String, dynamic> json) => Mcqquestions(
        prelimMcquesNum: int.parse(json["prelim_mcques_num"]),
        tNum: int.parse(json["t_num"]),
        prelimMcquesQuestion: json["prelim_mcques_question"],
        prelimMcqId: int.parse(json["prelim_mcq_id"]),
      );

  Map<String, dynamic> toJson() => {
        "prelim_mcques_num": prelimMcquesNum,
        "t_num": tNum,
        "prelim_mcques_question": prelimMcquesQuestion,
        "prelim_mcq_id": prelimMcqId,
      };
}
