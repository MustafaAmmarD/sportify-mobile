// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  email: json['email'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  accessToken: json['accessToken'] as String?,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'role': _$UserRoleEnumMap[instance.role]!,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'avatarUrl': instance.avatarUrl,
  'accessToken': instance.accessToken,
};

const _$UserRoleEnumMap = {
  UserRole.player: 'player',
  UserRole.club: 'club',
  UserRole.agent: 'agent',
  UserRole.scout: 'scout',
  UserRole.coach: 'coach',
  UserRole.fan: 'fan',
  UserRole.companyHr: 'company_hr',
};
