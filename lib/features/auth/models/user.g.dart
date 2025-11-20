// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  userId: stringToInt(json['user_id']),
  username: json['username'] as String,
  isAdmin: json['is_admin'] == null ? 0 : stringToInt(json['is_admin']),
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'user_id': intToString(instance.userId),
      'username': instance.username,
      'is_admin': intToString(instance.isAdmin),
    };
