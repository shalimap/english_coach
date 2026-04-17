import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<Qualifications> qualificationsFromJson(String str) =>
    List<Qualifications>.from(
        json.decode(str).map((x) => Qualifications.fromJson(x)));

String qualificationsToJson(List<Qualifications> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Qualifications with ChangeNotifier {
  Qualifications({
    this.qualId,
    this.qualName,
  });

  String? qualId;
  String? qualName;

  factory Qualifications.fromJson(Map<String, dynamic> json) => Qualifications(
        qualId: json["qual_id"],
        qualName: json["qual_name"],
      );

  Map<String, dynamic> toJson() => {
        "qual_id": qualId,
        "qual_name": qualName,
      };
}
