import 'dart:convert';

List<Pictogrammarksheet> pictogrammarksheetFromJson(String str) =>
    List<Pictogrammarksheet>.from(
        json.decode(str).map((x) => Pictogrammarksheet.fromJson(x)));

String pictogrammarksheetToJson(List<Pictogrammarksheet> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pictogrammarksheet {
  Pictogrammarksheet({
    this.id,
    this.userId,
    this.modId,
    this.picId,
    this.sentence,
  });

  int? id;
  int? userId;
  int? modId;
  int? picId;
  String? sentence;

  factory Pictogrammarksheet.fromJson(Map<String, dynamic> json) =>
      Pictogrammarksheet(
        id: int.parse(json["id"]),
        userId: int.parse(json["user_id"]),
        modId: int.parse(json["mod_id"]),
        picId: int.parse(json["pic_id"]),
        sentence: json["sentence"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "mod_id": modId,
        "pic_id": picId,
        "sentence": sentence,
      };
}
