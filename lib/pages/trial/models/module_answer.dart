import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<ModuleAnswer> moduleAnswerFromJson(String str) => List<ModuleAnswer>.from(
    json.decode(str).map((x) => ModuleAnswer.fromJson(x)));

String moduleAnswerToJson(List<ModuleAnswer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModuleAnswer with ChangeNotifier {
  ModuleAnswer({
    this.modAnsId,
    this.modQueNum,
    this.modAnsAnswer,
  });

  int? modAnsId;
  int? modQueNum;
  String? modAnsAnswer;

  factory ModuleAnswer.fromJson(Map<String, dynamic> json) => ModuleAnswer(
        modAnsId: int.parse(json["mod_ans_id"]),
        modQueNum: int.parse(json["mod_que_num"]),
        modAnsAnswer: json["mod_ans_answer"],
      );

  Map<String, dynamic> toJson() => {
        "mod_ans_id": modAnsId,
        "mod_que_num": modQueNum,
        "mod_ans_answer": modAnsAnswer,
      };
}
