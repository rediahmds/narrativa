import 'dart:convert';
import 'package:narrativa/models/models.dart';

class StoryDetailResponse {
  final bool error;
  final String message;
  final Story story;

  StoryDetailResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  factory StoryDetailResponse.fromJson(String str) =>
      StoryDetailResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StoryDetailResponse.fromMap(Map<String, dynamic> json) =>
      StoryDetailResponse(
        error: json["error"],
        message: json["message"],
        story: Story.fromMap(json["story"]),
      );

  Map<String, dynamic> toMap() => {
    "error": error,
    "message": message,
    "story": story.toMap(),
  };
}
