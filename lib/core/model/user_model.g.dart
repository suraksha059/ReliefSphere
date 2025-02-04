// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      userRole: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ??
          UserRole.victim,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      phoneNumber: json['phoneNumber'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      log: (json['log'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'avatar': instance.avatar,
      'phoneNumber': instance.phoneNumber,
      'lat': instance.lat,
      'log': instance.log,
      'role': _$UserRoleEnumMap[instance.userRole]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.victim: 'victim',
  UserRole.donor: 'donor',
  UserRole.admin: 'admin',
};
