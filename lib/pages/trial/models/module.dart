import 'package:flutter/foundation.dart';
import 'dart:convert';

List<Module> moduleFromJson(String str) =>
    List<Module>.from(json.decode(str).map((x) => Module.fromJson(x)));

String moduleToJson(List<Module> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Module with ChangeNotifier {
  final int? modNum;
  final int? modOrder;
  final int? tNum;
  final String? modName;
  final String? modContent;
  final String? modDescription;
  final String? modSpecialnote;
  final String? slLevel;
  final int? modExampleExplanation;

  Module({
    this.modNum,
    this.modOrder,
    this.tNum,
    this.modName,
    this.modContent,
    this.modDescription,
    this.modSpecialnote,
    this.slLevel,
    this.modExampleExplanation,
  });

  factory Module.fromJson(Map<String, dynamic> json) => Module(
        modNum: int.parse(json["mod_num"]),
        modOrder: int.parse(json["mod_order"]),
        tNum: int.parse(json["t_num"]),
        modName: json["mod_name"],
        modContent: json["mod_content"],
        modDescription: json["mod_description"],
        modSpecialnote: json["mod_specialnote"],
        slLevel: json["sl_level"],
        modExampleExplanation: int.parse(json["mod_example_explanation"]),
      );

  Map<String, dynamic> toJson() => {
        "mod_num": modNum,
        "mod_order": modOrder,
        "t_num": tNum,
        "mod_name": modName,
        "mod_content": modContent,
        "mod_description": modDescription,
        "mod_specialnote": modSpecialnote,
        "sl_level": slLevel,
        "mod_example_explanation": modExampleExplanation,
      };
}
