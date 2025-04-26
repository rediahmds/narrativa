import 'dart:convert';
import 'package:narrativa/models/models.dart';

class LoginResponse {
  final bool error;
  final String message;
  final LoginResult loginResult;

  LoginResponse({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  factory LoginResponse.fromJson(String str) =>
      LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

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
