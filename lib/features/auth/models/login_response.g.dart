// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseImpl _$$LoginResponseImplFromJson(Map<String, dynamic> json) =>
    _$LoginResponseImpl(
      success: json['success'] as bool,
      message: json['message'] as String,
      userId: nullableStringToInt(json['user_id']),
      username: json['username'] as String?,
      isAdmin: nullableStringToInt(json['is_admin']),
    );

Map<String, dynamic> _$$LoginResponseImplToJson(_$LoginResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'user_id': intToNullableString(instance.userId),
      'username': instance.username,
      'is_admin': intToNullableString(instance.isAdmin),
    };
