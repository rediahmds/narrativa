import 'package:narrativa/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story_detail_response.g.dart';

@JsonSerializable()
class StoryDetailResponse {
  final bool error;
  final String message;
  final Story story;

  StoryDetailResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  factory StoryDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryDetailResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StoryDetailResponseToJson(this);

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
