import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<AudioChatRoom> audioChatRoomFromJson(String str) =>
    List<AudioChatRoom>.from(
        json.decode(str).map((x) => AudioChatRoom.fromJson(x)));

String audioChatRoomToJson(List<AudioChatRoom> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AudioChatRoom with ChangeNotifier {
  AudioChatRoom({
    required this.chatRoomId,
    required this.chatContentId,
    required this.userId,
    required this.audio,
    required this.firebaseUrl,
    required this.block,
    required this.active,
  });

  final String chatRoomId;
  final String chatContentId;
  final String userId;
  final String audio;
  final String firebaseUrl;
  final String block;
  final String active;

  factory AudioChatRoom.fromJson(Map<String, dynamic> json) => AudioChatRoom(
        chatRoomId: json["chat_room_id"],
        chatContentId: json["chat_content_id"],
        userId: json["user_id"],
        audio: json["audio"],
        firebaseUrl: json["firebase_audio_url"],
        block: json["block"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "chat_room_id": chatRoomId,
        "chat_content_id": chatContentId,
        "user_id": userId,
        "audio": audio,
        "firebase_audio_url": firebaseUrl,
        "block": block,
        "active": active,
      };
}
