import 'dart:convert';
import 'package:flutter/cupertino.dart';

List<PopUpList> popUpListFromJson(String str) =>
    List<PopUpList>.from(json.decode(str).map((x) => PopUpList.fromJson(x)));
String popUpListToJson(List<PopUpList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PopUpList with ChangeNotifier {
  PopUpList({
    this.popupId,
    this.popupUrl,
  });

  int? popupId;
  String? popupUrl;

  factory PopUpList.fromJson(Map<String, dynamic> json) => PopUpList(
        popupId: int.parse(json["popup_id"]),
        popupUrl: json["popup_url"],
      );

  Map<String, dynamic> toJson() => {
        "popup_id": popupId,
        "popup_url": popupUrl,
      };
}
