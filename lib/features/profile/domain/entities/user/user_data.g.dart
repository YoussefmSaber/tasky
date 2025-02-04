// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

/// Converts a JSON map to a `UserData` instance.
UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      id: json['_id'] as String?,
      displayName: json['displayName'] as String?,
      phoneNumber: json['username'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
      active: json['active'] as bool?,
      experienceYears: (json['experienceYears'] as num?)?.toInt(),
      address: json['address'] as String?,
      level: json['level'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      V: (json['__v'] as num?)?.toInt(),
    );

/// Converts a `UserData` instance to a JSON map.
Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      '_id': instance.id,
      'displayName': instance.displayName,
      'username': instance.phoneNumber,
      'roles': instance.roles,
      'active': instance.active,
      'experienceYears': instance.experienceYears,
      'address': instance.address,
      'level': instance.level,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '__v': instance.V,
    };
