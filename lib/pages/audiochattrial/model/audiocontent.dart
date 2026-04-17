import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<AudioContent> audioContentFromJson(String str) => List<AudioContent>.from(
    json.decode(str).map((x) => AudioContent.fromJson(x)));

String audioContentToJson(List<AudioContent> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AudioContent with ChangeNotifier {
  AudioContent({
    required this.audioContentId,
    required this.subject,
    required this.paragraph,
    required this.level,
  });

  final String audioContentId;
  final String subject;
  final String paragraph;
  final String level;

  factory AudioContent.fromJson(Map<String, dynamic> json) => AudioContent(
        audioContentId: json["audio_content_id"],
        subject: json["subject"],
        paragraph: json["paragraph"],
        level: json["level"],
      );

  Map<String, dynamic> toJson() => {
        "audio_content_id": audioContentId,
        "subject": subject,
        "paragraph": paragraph,
        "level": level,
      };
}
