import 'dart:convert';

class LoginResult {
  final String userId;
  final String name;
  final String token;

  LoginResult({required this.userId, required this.name, required this.token});

  factory LoginResult.fromJson(String str) =>
      LoginResult.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResult.fromMap(Map<String, dynamic> json) => LoginResult(
    userId: json["userId"],
    name: json["name"],
    token: json["token"],
  );

  Map<String, dynamic> toMap() => {
    "userId": userId,
    "name": name,
    "token": token,
  };
}
