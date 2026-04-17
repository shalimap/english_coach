import 'dart:convert';
import 'package:flutter/foundation.dart';

List<Example> exampleFromJson(String str) =>
    List<Example>.from(json.decode(str).map((x) => Example.fromJson(x)));

String exampleToJson(List<Example> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Example with ChangeNotifier {
  Example({
    this.exNum,
    this.modNum,
    this.exExample,
  });

  int? exNum;
  int? modNum;
  String? exExample;

  factory Example.fromJson(Map<String, dynamic> json) => Example(
        exNum: int.parse(json["ex_num"]),
        modNum: int.parse(json["mod_num"]),
        exExample: json["ex_example"],
      );

  Map<String, dynamic> toJson() => {
        "ex_num": exNum,
        "mod_num": modNum,
        "ex_example": exExample,
      };
}
