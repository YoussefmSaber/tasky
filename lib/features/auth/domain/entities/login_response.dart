import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

/// A class representing the response received after a login attempt.
@JsonSerializable()
class LoginResponse {
  /// The unique identifier for the user.
  @JsonKey(name: '_id')
  final String? id;

  /// The access token for the user session.
  @JsonKey(name: 'access_token')
  final String? accessToken;

  /// The refresh token for the user session.
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  /// Creates a new instance of [LoginResponse].
  const LoginResponse({
    this.id,
    this.accessToken,
    this.refreshToken,
  });

  /// Creates a new instance of [LoginResponse] from a JSON object.
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  /// Converts the [LoginResponse] instance to a JSON object.
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}