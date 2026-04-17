import 'dart:convert';
import 'package:flutter/cupertino.dart';

List<Audio> audioFromJson(String str) =>
    List<Audio>.from(json.decode(str).map((x) => Audio.fromJson(x)));

String audioToJson(List<Audio> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Audio with ChangeNotifier {
  Audio({
    this.audNum,
    this.audName,
    this.audLevel,
  });

  int? audNum;
  String? audName;
  String? audLevel;

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
        audNum: int.parse(json["aud_num"]),
        audName: json["aud_name"],
        audLevel: json["aud_level"],
      );

  Map<String, dynamic> toJson() => {
        "aud_num": audNum,
        "aud_name": audName,
        "aud_level": audLevel,
      };
}
