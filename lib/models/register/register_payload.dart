import 'package:json_annotation/json_annotation.dart';

part 'register_payload.g.dart';

@JsonSerializable()
class RegisterPayload {
  final String name;
  final String email;
  final String password;

  RegisterPayload({
    required this.name,
    required this.email,
    required this.password,
  });

  factory RegisterPayload.fromJson(Map<String, dynamic> json) =>
      _$RegisterPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterPayloadToJson(this);

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
