import 'dart:convert';

class AddStoryResponse {
  final bool error;
  final String message;

  AddStoryResponse({required this.error, required this.message});

  factory AddStoryResponse.fromJson(String str) =>
      AddStoryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddStoryResponse.fromMap(Map<String, dynamic> json) =>
      AddStoryResponse(error: json["error"], message: json["message"]);

  Map<String, dynamic> toMap() => {"error": error, "message": message};
}
