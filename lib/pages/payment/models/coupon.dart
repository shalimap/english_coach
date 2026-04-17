import 'dart:convert';
import 'package:flutter/cupertino.dart';

List<Coupon> couponFromJson(String str) =>
    List<Coupon>.from(json.decode(str).map((x) => Coupon.fromJson(x)));
String couponToJson(List<Coupon> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Coupon with ChangeNotifier {
  Coupon({
    this.couponId,
    this.couponName,
    this.couponReduction,
    this.couponCount,
  });
  int? couponId;
  String? couponName;
  int? couponReduction;
  int? couponCount;
  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        couponId: int.parse(json["coupon_id"]),
        couponName: json["coupon_name"],
        couponReduction: int.parse(json["coupon_reduction"]),
        couponCount: int.parse(json["coupon_count"]),
      );
  Map<String, dynamic> toJson() => {
        "coupon_id": couponId,
        "coupon_name": couponName,
        "coupon_reduction": couponReduction,
        "coupon_count": couponCount,
      };
}
