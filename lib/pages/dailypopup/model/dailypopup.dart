import 'dart:convert';
import 'package:flutter/cupertino.dart';

List<DailyPopUp> dailyPopUpFromJson(String str) =>
    List<DailyPopUp>.from(json.decode(str).map((x) => DailyPopUp.fromJson(x)));
String dailyPopUpToJson(List<DailyPopUp> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DailyPopUp with ChangeNotifier {
  DailyPopUp({
    this.id,
    this.userId,
    this.popupId,
    this.dateTime,
    this.count,
  });

  int? id;
  int? userId;
  int? popupId;
  DateTime? dateTime;
  int? count;

  factory DailyPopUp.fromJson(Map<String, dynamic> json) => DailyPopUp(
        id: int.parse(json["id"]),
        userId: int.parse(json["user_id"]),
        popupId: int.parse(json["popup_id"]),
        dateTime: DateTime.parse(json["date_time"]),
        count: int.parse(json["count"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "popup_id": popupId,
        "date_time": dateTime!.toIso8601String(),
        "count": count,
      };
}
