import 'dart:convert';

import 'package:flutter/foundation.dart';

List<Section> sectionFromJson(String str) =>
    List<Section>.from(json.decode(str).map((x) => Section.fromJson(x)));

String sectionToJson(List<Section> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Section with ChangeNotifier {
  Section({
    this.secId,
    this.secName,
  });

  int? secId;
  String? secName;

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        secId: int.parse(json["sec_id"]),
        secName: json["sec_name"],
      );

  Map<String, dynamic> toJson() => {
        "sec_id": secId,
        "sec_name": secName,
      };
}
