import 'package:flutter/foundation.dart';

import 'dart:convert';

List<States> statesFromJson(String str) =>
    List<States>.from(json.decode(str).map((x) => States.fromJson(x)));

String statesToJson(List<States> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class States with ChangeNotifier {
  States({
    this.stateId,
    this.stateName,
  });

  int? stateId;
  String? stateName;

  factory States.fromJson(Map<String, dynamic> json) => States(
        stateId: int.parse(json["state_id"]),
        stateName: json["state_name"],
      );

  Map<String, dynamic> toJson() => {
        "state_id": stateId,
        "state_name": stateName,
      };
}

List<Districts> districtsFromJson(String str) =>
    List<Districts>.from(json.decode(str).map((x) => Districts.fromJson(x)));

String districtsToJson(List<Districts> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Districts with ChangeNotifier {
  Districts({
    this.distId,
    this.stateId,
    this.distName,
  });

  int? distId;
  int? stateId;
  String? distName;

  factory Districts.fromJson(Map<String, dynamic> json) => Districts(
        distId: int.parse(json["dist_id"]),
        stateId: int.parse(json["state_id"]),
        distName: json["dist_name"],
      );

  Map<String, dynamic> toJson() => {
        "dist_id": distId,
        "state_id": stateId,
        "dist_name": distName,
      };
}
