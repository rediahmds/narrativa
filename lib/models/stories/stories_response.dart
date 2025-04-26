import 'dart:convert';

import 'package:narrativa/models/models.dart';

class StoriesResponse {
  final bool error;
  final String message;
  final List<Story> listStory;

  StoriesResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory StoriesResponse.fromJson(String str) =>
      StoriesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StoriesResponse.fromMap(Map<String, dynamic> json) => StoriesResponse(
    error: json["error"],
    message: json["message"],
    listStory: List<Story>.from(json["listStory"].map((x) => Story.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "error": error,
    "message": message,
    "listStory": List<dynamic>.from(listStory.map((x) => x.toMap())),
  };
}
