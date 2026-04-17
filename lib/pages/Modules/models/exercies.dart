import 'package:flutter/foundation.dart';
import 'dart:convert';

List<Exercises> exercisesFromJson(String str) =>
    List<Exercises>.from(json.decode(str).map((x) => Exercises.fromJson(x)));

String exercisesToJson(List<Exercises> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Exercises with ChangeNotifier {
  Exercises({
    this.exeNum,
    this.modNum,
    this.exeQuestion,
    this.exeAnswer,
    this.exeSentenceRule,
  });

  int? exeNum;
  int? modNum;
  String? exeQuestion;
  String? exeAnswer;
  int? exeSentenceRule;

  factory Exercises.fromJson(Map<String, dynamic> json) => Exercises(
        exeNum: int.parse(json["exe_num"]),
        modNum: int.parse(json["mod_num"]),
        exeQuestion: json["exe_question"],
        exeAnswer: json["exe_answer"],
        exeSentenceRule: int.parse(json["exe_sentence_rule"]),
      );

  Map<String, dynamic> toJson() => {
        "exe_num": exeNum,
        "mod_num": modNum,
        "exe_question": exeQuestion,
        "exe_answer": exeAnswer,
        "exe_sentence_rule": exeSentenceRule,
      };
}
