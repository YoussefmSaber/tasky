// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_register.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegister _$UserRegisterFromJson(Map<String, dynamic> json) => UserRegister(
      phone: json['phone'] as String?,
      password: json['password'] as String?,
      displayName: json['displayName'] as String?,
      experienceYears: (json['experienceYears'] as num?)?.toInt(),
      address: json['address'] as String?,
      level: json['level'] as String?,
    );

Map<String, dynamic> _$UserRegisterToJson(UserRegister instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'password': instance.password,
      'displayName': instance.displayName,
      'experienceYears': instance.experienceYears,
      'address': instance.address,
      'level': instance.level,
    };
