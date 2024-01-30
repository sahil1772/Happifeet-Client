// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      parent_user_id: json['parent_user_id'] as String?,
      user_id: json['user_id'] as String?,
      user_name: json['user_name'] as String?,
      user_type: json['user_type'] as String?,
      client_id: json['client_id'] as String?,
      access: json['access'] == null
          ? null
          : AccessPermissionData.fromJson(
              json['access'] as Map<String, dynamic>),
      language: json['language'] as Map<String, dynamic>?,
      theme_data: json['theme_data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'parent_user_id': instance.parent_user_id,
      'user_id': instance.user_id,
      'user_name': instance.user_name,
      'user_type': instance.user_type,
      'client_id': instance.client_id,
      'access': instance.access,
      'language': instance.language,
      'theme_data': instance.theme_data,
    };
