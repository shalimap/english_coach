import 'dart:convert';
import 'package:flutter/cupertino.dart';

List<AudioLock> audioLockFromJson(String str) =>
    List<AudioLock>.from(json.decode(str).map((x) => AudioLock.fromJson(x)));

String audioLockToJson(List<AudioLock> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AudioLock with ChangeNotifier {
  AudioLock({
    this.audLockId,
    this.userId,
    this.audNum,
    this.audLockOpen,
    this.audUnlockedTime,
  });

  int? audLockId;
  int? userId;
  int? audNum;
  int? audLockOpen;
  DateTime? audUnlockedTime;

  factory AudioLock.fromJson(Map<String, dynamic> json) => AudioLock(
        audLockId: int.parse(json["aud_lock_id"]),
        userId: int.parse(json["user_id"]),
        audNum: int.parse(json["aud_num"]),
        audLockOpen: int.parse(json["aud_lock_open"]),
        audUnlockedTime: DateTime.parse(json["aud_unlocked_time"]),
      );

  Map<String, dynamic> toJson() => {
        "aud_lock_id": audLockId,
        "user_id": userId,
        "aud_num": audNum,
        "aud_lock_open": audLockOpen,
        "aud_unlocked_time": audUnlockedTime!.toIso8601String(),
      };
}
