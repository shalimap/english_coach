import 'dart:convert';
import 'package:flutter/cupertino.dart';

List<AudioMarksheet> audioMarksheetFromJson(String str) =>
    List<AudioMarksheet>.from(
        json.decode(str).map((x) => AudioMarksheet.fromJson(x)));

String audioMarksheetToJson(List<AudioMarksheet> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AudioMarksheet with ChangeNotifier {
  AudioMarksheet({
    this.audMarkId,
    this.audTestId,
    this.userId,
    this.audNum,
    this.audQuesNum,
    this.audAnswered,
  });

  int? audMarkId;
  int? audTestId;
  int? userId;
  int? audNum;
  int? audQuesNum;
  String? audAnswered;

  factory AudioMarksheet.fromJson(Map<String, dynamic> json) => AudioMarksheet(
        audMarkId: int.parse(json["aud_mark_id"]),
        audTestId: int.parse(json["aud_test_id"]),
        userId: int.parse(json["user_id"]),
        audNum: int.parse(json["aud_num"]),
        audQuesNum: int.parse(json["aud_ques_num"]),
        audAnswered: json["aud_answered"],
      );

  Map<String, dynamic> toJson() => {
        "aud_mark_id": audMarkId,
        "aud_test_id": audTestId,
        "user_id": userId,
        "aud_num": audNum,
        "aud_ques_num": audQuesNum,
        "aud_answered": audAnswered,
      };
}
