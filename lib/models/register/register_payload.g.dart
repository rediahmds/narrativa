// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterPayload _$RegisterPayloadFromJson(Map<String, dynamic> json) =>
    RegisterPayload(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$RegisterPayloadToJson(RegisterPayload instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
    };
