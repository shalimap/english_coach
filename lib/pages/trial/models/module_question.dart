import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<ModuleQuestion> moduleQuestionFromJson(String str) =>
    List<ModuleQuestion>.from(
        json.decode(str).map((x) => ModuleQuestion.fromJson(x)));

String moduleQuestionToJson(List<ModuleQuestion> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModuleQuestion with ChangeNotifier {
  ModuleQuestion({
    this.modQueNum,
    this.modId,
    this.tNum,
    this.modQueQuestion,
  });

  int? modQueNum;
  int? modId;
  int? tNum;
  String? modQueQuestion;

  factory ModuleQuestion.fromJson(Map<String, dynamic> json) => ModuleQuestion(
        modQueNum: int.parse(json["mod_que_num"]),
        modId: int.parse(json["mod_id"]),
        tNum: int.parse(json["t_num"]),
        modQueQuestion: json["mod_que_question"],
      );

  Map<String, dynamic> toJson() => {
        "mod_que_num": modQueNum,
        "mod_id": modId,
        "t_num": tNum,
        "mod_que_question": modQueQuestion,
      };
}
