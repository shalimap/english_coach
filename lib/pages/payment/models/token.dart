// To parse this JSON data, do
//
//     final token = tokenFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<Token> tokenFromJson(String str) =>
    List<Token>.from(json.decode(str).map((x) => Token.fromJson(x)));

String tokenToJson(List<Token> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Token with ChangeNotifier {
  Token({
    this.tokenId,
    this.userId,
    this.tokenNum,
    this.generatedTime,
    this.validTill,
    this.expired,
  });

  int? tokenId;
  int? userId;
  int? tokenNum;
  DateTime? generatedTime;
  DateTime? validTill;
  int? expired;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        tokenId: int.parse(json["token_id"]),
        userId: int.parse(json["user_id"]),
        tokenNum: int.parse(json["token_num"]),
        generatedTime: DateTime.parse(json["generated_time"]),
        validTill: DateTime.parse(json["valid_till"]),
        expired: int.parse(json["expired"]),
      );

  Map<String, dynamic> toJson() => {
        "token_id": tokenId,
        "user_id": userId,
        "token_num": tokenNum,
        "generated_time": generatedTime!.toIso8601String(),
        "valid_till": validTill!.toIso8601String(),
        "expired": expired,
      };
}
