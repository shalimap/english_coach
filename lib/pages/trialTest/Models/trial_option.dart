import 'dart:convert';

List<Trialoptions> trialoptionsFromJson(String str) => List<Trialoptions>.from(
    json.decode(str).map((x) => Trialoptions.fromJson(x)));

String trialoptionsToJson(List<Trialoptions> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Trialoptions {
  Trialoptions({
    this.trialMcqId,
    this.trialMcqNum,
    this.trialMcqAnswer,
  });

  int? trialMcqId;
  int? trialMcqNum;
  String? trialMcqAnswer;

  factory Trialoptions.fromJson(Map<String, dynamic> json) => Trialoptions(
        trialMcqId: int.parse(json["trial_mcq_id"]),
        trialMcqNum: int.parse(json["trial_mcq_num"]),
        trialMcqAnswer: json["trial_mcq_answer"],
      );

  Map<String, dynamic> toJson() => {
        "trial_mcq_id": trialMcqId,
        "trial_mcq_num": trialMcqNum,
        "trial_mcq_answer": trialMcqAnswer,
      };
}
