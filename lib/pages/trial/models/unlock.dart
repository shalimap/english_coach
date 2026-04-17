import 'package:flutter/material.dart';

import 'dart:convert';

List<Unlock> unlockFromJson(String str) =>
    List<Unlock>.from(json.decode(str).map((x) => Unlock.fromJson(x)));

String unlockToJson(List<Unlock> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Unlock with ChangeNotifier {
  Unlock({
    this.mLockId,
    this.userId,
    this.modNum,
    this.mLockOpenNow,
    this.mLockUnlockedTime,
  });

  int? mLockId;
  int? userId;
  int? modNum;
  int? mLockOpenNow;
  DateTime? mLockUnlockedTime;

  factory Unlock.fromJson(Map<String, dynamic> json) => Unlock(
        mLockId: int.parse(json["mlock_id"]),
        userId: int.parse(json["user_id"]),
        modNum: int.parse(json["mod_num"]),
        mLockOpenNow: int.parse(json["mlock_open_now"]),
        mLockUnlockedTime: DateTime.parse(json["mlock_unlocked_time"]),
      );

  Map<String, dynamic> toJson() => {
        "mlock_id": mLockId,
        "user_id": userId,
        "mod_num": modNum,
        "mlock_open_now": mLockOpenNow,
        "mlock_unlocked_time": mLockUnlockedTime!.toIso8601String(),
      };
}
