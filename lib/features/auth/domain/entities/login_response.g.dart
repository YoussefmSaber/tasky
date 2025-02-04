// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

/// \[JsonSerializable\] generated code for \[LoginResponse\] class.
///
/// This code includes functions to convert \[LoginResponse\] instances
/// to and from JSON format.
LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      id: json['_id'] as String?,
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
    );

/// Converts a \[LoginResponse\] instance to a JSON map.
Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };