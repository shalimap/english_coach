import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<AudioChatUser> audioChatUserFromJson(String str) =>
    List<AudioChatUser>.from(
        json.decode(str).map((x) => AudioChatUser.fromJson(x)));

String audioChatUserToJson(List<AudioChatUser> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AudioChatUser with ChangeNotifier {
  AudioChatUser({
    required this.roomId,
    required this.userId,
    required this.roomEndTime,
    required this.roomStatus,
  });

  final String roomId;
  final String userId;
  final String roomEndTime;
  final String roomStatus;

  factory AudioChatUser.fromJson(Map<String, dynamic> json) => AudioChatUser(
        roomId: json["room_id"],
        userId: json["user_id"],
        roomEndTime: json["room_end_time"],
        roomStatus: json["room_status"],
      );

  Map<String, dynamic> toJson() => {
        "room_id": roomId,
        "user_id": userId,
        "room_end_time": roomEndTime,
        "room_status": roomStatus,
      };
}
