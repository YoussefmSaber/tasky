import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_response.g.dart';

/// A class representing the response for a refresh token request.
@JsonSerializable()
class RefreshTokenResponse {
  /// The access token returned in the response.
  @JsonKey(name: 'access_token')
  final String? accessToken;

  /// Constructs a [RefreshTokenResponse] instance.
  const RefreshTokenResponse({
    this.accessToken,
  });

  /// Creates a [RefreshTokenResponse] from a JSON map.
  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);

  /// Converts the [RefreshTokenResponse] instance to a JSON map.
  Map<String, dynamic> toJson() => _$RefreshTokenResponseToJson(this);
}