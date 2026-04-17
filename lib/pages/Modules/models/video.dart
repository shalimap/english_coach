import 'dart:convert';

List<Modulevideo> modulevideoFromJson(String str) => List<Modulevideo>.from(
    json.decode(str).map((x) => Modulevideo.fromJson(x)));

String modulevideoToJson(List<Modulevideo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Modulevideo {
  Modulevideo({
    this.videoId,
    this.modId,
    this.videoUrl,
    this.videoDesc,
  });

  String? videoId;
  String? modId;
  String? videoUrl;
  String? videoDesc;

  factory Modulevideo.fromJson(Map<String, dynamic> json) => Modulevideo(
        videoId: json["video_id"],
        modId: json["mod_id"],
        videoUrl: json["video_url"],
        videoDesc: json["video_desc"],
      );

  Map<String, dynamic> toJson() => {
        "video_id": videoId,
        "mod_id": modId,
        "video_url": videoUrl,
        "video_desc": videoDesc,
      };
}
