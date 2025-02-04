import 'package:json_annotation/json_annotation.dart';

part 'user_register.g.dart';

/// A class representing a user registration entity.
@JsonSerializable()
class UserRegister {
  /// The phone number of the user.
  final String? phone;

  /// The password of the user.
  final String? password;

  /// The display name of the user.
  final String? displayName;

  /// The number of years of experience the user has.
  final int? experienceYears;

  /// The address of the user.
  final String? address;

  /// The level of the user.
  final String? level;

  /// Creates a new instance of [UserRegister].
  const UserRegister({
    this.phone,
    this.password,
    this.displayName,
    this.experienceYears,
    this.address,
    this.level,
  });

  /// Creates a new instance of [UserRegister] from a JSON object.
  factory UserRegister.fromJson(Map<String, dynamic> json) =>
      _$UserRegisterFromJson(json);

  /// Converts the [UserRegister] instance to a JSON object.
  Map<String, dynamic> toJson() => _$UserRegisterToJson(this);
}