import 'dart:convert';

class LoginPayload {
  final String email;
  final String password;

  LoginPayload({required this.email, required this.password});

  factory LoginPayload.fromJson(String str) =>
      LoginPayload.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginPayload.fromMap(Map<String, dynamic> json) =>
      LoginPayload(email: json["email"], password: json["password"]);

  Map<String, dynamic> toMap() => {"email": email, "password": password};
}
