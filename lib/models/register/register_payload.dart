import 'dart:convert';

class RegisterPayload {
  final String name;
  final String email;
  final String password;

  RegisterPayload({
    required this.name,
    required this.email,
    required this.password,
  });

  factory RegisterPayload.fromJson(String str) =>
      RegisterPayload.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegisterPayload.fromMap(Map<String, dynamic> json) => RegisterPayload(
    name: json["name"],
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "email": email,
    "password": password,
  };
}
