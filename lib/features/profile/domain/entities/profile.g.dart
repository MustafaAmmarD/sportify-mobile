// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  id: json['id'] as String,
  userId: json['userId'] as String,
  bio: json['bio'] as String?,
  position: json['position'] as String?,
  nationality: json['nationality'] as String?,
  preferredFoot: json['preferredFoot'] as String?,
  heightCm: (json['heightCm'] as num?)?.toInt(),
  weightKg: (json['weightKg'] as num?)?.toInt(),
  videoLinks:
      (json['videoLinks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  isAvailableForTransfer: json['isAvailableForTransfer'] as bool? ?? false,
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'bio': instance.bio,
  'position': instance.position,
  'nationality': instance.nationality,
  'preferredFoot': instance.preferredFoot,
  'heightCm': instance.heightCm,
  'weightKg': instance.weightKg,
  'videoLinks': instance.videoLinks,
  'isAvailableForTransfer': instance.isAvailableForTransfer,
};
