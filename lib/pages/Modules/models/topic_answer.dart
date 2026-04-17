import 'dart:convert';

List<TopicAnswer> topicAnswerFromJson(String str) => List<TopicAnswer>.from(
    json.decode(str).map((x) => TopicAnswer.fromJson(x)));

String topicAnswerToJson(List<TopicAnswer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TopicAnswer {
  TopicAnswer({
    this.topicAnsId,
    this.topicQueNum,
    this.topicAnsAnswer,
  });

  int? topicAnsId;
  int? topicQueNum;
  String? topicAnsAnswer;

  factory TopicAnswer.fromJson(Map<String, dynamic> json) => TopicAnswer(
        topicAnsId: int.parse(json["topic_ans_id"]),
        topicQueNum: int.parse(json["topic_que_num"]),
        topicAnsAnswer: json["topic_ans_answer"],
      );

  Map<String, dynamic> toJson() => {
        "topic_ans_id": topicAnsId,
        "topic_que_num": topicQueNum,
        "topic_ans_answer": topicAnsAnswer,
      };
}
