import 'dart:convert';

List<Pictogramanswers> pictogramanswersFromJson(String str) =>
    List<Pictogramanswers>.from(
        json.decode(str).map((x) => Pictogramanswers.fromJson(x)));

String pictogramanswersToJson(List<Pictogramanswers> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pictogramanswers {
  Pictogramanswers({
    this.picAnsId,
    this.picId,
    this.picAnswers,
  });

  int? picAnsId;
  int? picId;
  String? picAnswers;

  factory Pictogramanswers.fromJson(Map<String, dynamic> json) =>
      Pictogramanswers(
        picAnsId: int.parse(json["pic_ans_id"]),
        picId: int.parse(json["pic_id"]),
        picAnswers: json["pic_answers"],
      );

  Map<String, dynamic> toJson() => {
        "pic_ans_id": picAnsId,
        "pic_id": picId,
        "pic_answers": picAnswers,
      };
}
