import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

/// A class representing user data with various attributes.
@JsonSerializable()
class UserData {
  /// The unique identifier for the user.
  @JsonKey(name: '_id')
  final String? id;

  /// The display name of the user.
  final String? displayName;

  /// The phone number of the user.
  @JsonKey(name: 'username')
  final String? phoneNumber;

  /// The roles assigned to the user.
  final List<String>? roles;

  /// Indicates whether the user is active.
  final bool? active;

  /// The number of years of experience the user has.
  final int? experienceYears;

  /// The address of the user.
  final String? address;

  /// The level of the user.
  final String? level;

  /// The date and time when the user was created.
  final String? createdAt;

  /// The date and time when the user was last updated.
  final String? updatedAt;

  /// The version of the user data.
  @JsonKey(name: '__v')
  final int? V;

  /// Creates a new instance of [UserData].
  const UserData({
    this.id,
    this.displayName,
    this.phoneNumber,
    this.roles,
    this.active,
    this.experienceYears,
    this.address,
    this.level,
    this.createdAt,
    this.updatedAt,
    this.V,
  });

  /// Creates a new instance of [UserData] from a JSON object.
  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  /// Converts the [UserData] instance to a JSON object.
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}