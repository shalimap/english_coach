import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<Bank> bankFromJson(String str) =>
    List<Bank>.from(json.decode(str).map((x) => Bank.fromJson(x)));

String bankToJson(List<Bank> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bank with ChangeNotifier {
  Bank({
    this.bankName,
    this.bankAccnum,
    this.bankIfsc,
    this.bankBranch,
    this.bankId,
  });

  String? bankName;
  int? bankAccnum;
  String? bankIfsc;
  String? bankBranch;
  int? bankId;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        bankName: json["bank_name"],
        bankAccnum: int.parse(json["bank_accnum"]),
        bankIfsc: json["bank_ifsc"],
        bankBranch: json["bank_branch"],
        bankId: int.parse(json["bank_id"]),
      );

  Map<String, dynamic> toJson() => {
        "bank_name": bankName,
        "bank_accnum": bankAccnum,
        "bank_ifsc": bankIfsc,
        "bank_branch": bankBranch,
        "bank_id": bankId,
      };
}
