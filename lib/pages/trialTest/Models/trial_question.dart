import 'dart:convert';

List<Trialquestions> trialquestionsFromJson(String str) =>
    List<Trialquestions>.from(
        json.decode(str).map((x) => Trialquestions.fromJson(x)));

String trialquestionsToJson(List<Trialquestions> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Trialquestions {
  Trialquestions({
    this.trailMcqNum,
    this.modId,
    this.trailMcqQuestion,
    this.trialMcqId,
  });

  int? trailMcqNum;
  int? modId;
  String? trailMcqQuestion;
  int? trialMcqId;

  factory Trialquestions.fromJson(Map<String, dynamic> json) => Trialquestions(
        trailMcqNum: int.parse(json["trail_mcq_num"]),
        modId: int.parse(json["mod_id"]),
        trailMcqQuestion: json["trail_mcq_question"],
        trialMcqId: int.parse(json["trial_mcq_id"]),
      );

  Map<String, dynamic> toJson() => {
        "trail_mcq_num": trailMcqNum,
        "mod_id": modId,
        "trail_mcq_question": trailMcqQuestion,
        "trial_mcq_id": trialMcqId,
      };
}
