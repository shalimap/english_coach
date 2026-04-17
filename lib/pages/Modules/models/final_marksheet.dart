import 'dart:convert';

List<FinalMarksheet> finalMarksheetFromJson(String str) =>
    List<FinalMarksheet>.from(
        json.decode(str).map((x) => FinalMarksheet.fromJson(x)));

String finalMarksheetToJson(List<FinalMarksheet> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FinalMarksheet {
  FinalMarksheet({
    this.fmarksheetId,
    this.finalTestId,
    this.finalQuesNumber,
    this.finalUserAnswer,
  });

  int? fmarksheetId;
  int? finalTestId;
  int? finalQuesNumber;
  String? finalUserAnswer;

  factory FinalMarksheet.fromJson(Map<String, dynamic> json) => FinalMarksheet(
        fmarksheetId: int.parse(json["fmarksheet_id"]),
        finalTestId: int.parse(json["final_test_id"]),
        finalQuesNumber: int.parse(json["final_ques_number"]),
        finalUserAnswer: json["final_user_answer"],
      );

  Map<String, dynamic> toJson() => {
        "fmarksheet_id": fmarksheetId,
        "final_test_id": finalTestId,
        "final_ques_number": finalQuesNumber,
        "final_user_answer": finalUserAnswer,
      };
}
