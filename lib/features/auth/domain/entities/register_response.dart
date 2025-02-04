import 'package:json_annotation/json_annotation.dart';

part 'register_response.g.dart';

/// A class representing the response received after a successful registration.
@JsonSerializable()
class RegisterResponse {
  /// The unique identifier of the registered user.
  @JsonKey(name: '_id')
  final String? id;

  /// The display name of the registered user.
  final String? displayName;

  /// The access token provided upon registration.
  @JsonKey(name: 'access_token')
  final String? accessToken;

  /// The refresh token provided upon registration.
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  /// Creates a new instance of [RegisterResponse].
  const RegisterResponse({
    this.id,
    this.displayName,
    this.accessToken,
    this.refreshToken,
  });

  /// Creates a new instance of [RegisterResponse] from a JSON object.
  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  /// Converts the [RegisterResponse] instance to a JSON object.
  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}