// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_response.dart';

/// \[JsonSerializable\] generated code for \[RegisterResponse\] class.
/// This code handles the serialization and deserialization of the \[RegisterResponse\] object.

/// Converts a JSON \[Map\] into a \[RegisterResponse\] instance.
RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse(
      id: json['_id'] as String?,
      displayName: json['displayName'] as String?,
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
    );

/// Converts a \[RegisterResponse\] instance into a JSON \[Map\].
Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'displayName': instance.displayName,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };