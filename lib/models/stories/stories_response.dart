import 'package:narrativa/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stories_response.g.dart';

@JsonSerializable()
class StoriesResponse {
  final bool error;
  final String message;
  final List<Story> listStory;

  StoriesResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory StoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$StoriesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StoriesResponseToJson(this);

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
