import 'package:narrativa/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final bool error;
  final String message;
  final LoginResult loginResult;

  LoginResponse({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
    error: json["error"],
    message: json["message"],
    loginResult: LoginResult.fromMap(json["loginResult"]),
  );

  Map<String, dynamic> toMap() => {
    "error": error,
    "message": message,
    "loginResult": loginResult.toMap(),
  };
}
