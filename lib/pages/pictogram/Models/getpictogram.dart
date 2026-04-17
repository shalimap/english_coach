import 'dart:convert';

List<Pictogram> pictogramFromJson(String str) =>
    List<Pictogram>.from(json.decode(str).map((x) => Pictogram.fromJson(x)));

String pictogramToJson(List<Pictogram> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pictogram {
  Pictogram({
    this.picId,
    this.image,
    this.word,
    this.audioUrl,
    this.langId,
  });

  int? picId;
  String? image;
  String? word;
  String? audioUrl;
  int? langId;

  factory Pictogram.fromJson(Map<String, dynamic> json) => Pictogram(
        picId: int.parse(json["pic_id"]),
        image: json["image"],
        word: json["word"],
        audioUrl: json["audio_url"],
        langId: int.parse(json["lang_id"]),
      );

  Map<String, dynamic> toJson() => {
        "pic_id": picId,
        "image": image,
        "word": word,
        "audio_url": audioUrl,
        "lang_id": langId,
      };
}
