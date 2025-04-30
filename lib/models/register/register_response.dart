import 'package:json_annotation/json_annotation.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  final bool error;
  final String message;

  RegisterResponse({required this.error, required this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);

  factory RegisterResponse.fromMap(Map<String, dynamic> json) =>
      RegisterResponse(error: json["error"], message: json["message"]);

  Map<String, dynamic> toMap() => {"error": error, "message": message};
}
