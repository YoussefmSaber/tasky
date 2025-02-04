import 'package:json_annotation/json_annotation.dart';

part 'logout_response.g.dart';

/// A response object for logout operations.
@JsonSerializable()
class LogoutResponse {
  /// Indicates whether the logout was successful.
  final bool? success;

  /// Constructs a [LogoutResponse] instance.
  const LogoutResponse({
    this.success,
  });

  /// Creates a [LogoutResponse] from a JSON map.
  factory LogoutResponse.fromJson(Map<String, dynamic> json) =>
      _$LogoutResponseFromJson(json);

  /// Converts the [LogoutResponse] instance to a JSON map.
  Map<String, dynamic> toJson() => _$LogoutResponseToJson(this);
}