import 'package:flutter/material.dart';

import 'dart:convert';

List<OnlinePayment> unlockFromJson(String str) => List<OnlinePayment>.from(
    json.decode(str).map((x) => OnlinePayment.fromJson(x)));

String unlockToJson(List<OnlinePayment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OnlinePayment with ChangeNotifier {
  OnlinePayment({
    this.userId,
    this.razorpayId,
    this.status,
    this.time,
    this.code,
  });

  int? userId;
  String? razorpayId;
  int? status;
  DateTime? time;
  String? code;

  factory OnlinePayment.fromJson(Map<String, dynamic> json) => OnlinePayment(
        userId: int.parse(json["user_id"]),
        razorpayId: json["razorpay_id"],
        status: int.parse(json["status"]),
        time: DateTime.parse(json["time"]),
        code: json["razorpay_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "razorpay_id": razorpayId,
        "status": status,
        "time": time!.toIso8601String(),
        "code": code,
      };
}
