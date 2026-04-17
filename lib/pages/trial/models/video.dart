import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<Video> videoFromJson(String str) =>
    List<Video>.from(json.decode(str).map((x) => Video.fromJson(x)));

String videoToJson(List<Video> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Video with ChangeNotifier {
  Video({
    this.vidId,
    this.modId,
    this.vidUrl,
    this.vidDesc,
  });

  int? vidId;
  int? modId;
  String? vidUrl;
  String? vidDesc;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        vidId: int.parse(json["vid_id"]),
        modId: int.parse(json["mod_id"]),
        vidUrl: json["vid_url"],
        vidDesc: json["vid_desc"],
      );

  Map<String, dynamic> toJson() => {
        "vid_id": vidId,
        "mod_id": modId,
        "vid_url": vidUrl,
        "vid_desc": vidDesc,
      };
}
