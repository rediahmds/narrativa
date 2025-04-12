import 'dart:convert';

class RegisterResponse {
  final bool error;
  final String message;

  RegisterResponse({required this.error, required this.message});

  factory RegisterResponse.fromJson(String str) =>
      RegisterResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegisterResponse.fromMap(Map<String, dynamic> json) =>
      RegisterResponse(error: json["error"], message: json["message"]);

  Map<String, dynamic> toMap() => {"error": error, "message": message};
}
