// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EditClientUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditClientUser _$EditClientUserFromJson(Map<String, dynamic> json) =>
    EditClientUser(
      client_user_id: json['client_user_id'] as String?,
      client_name: json['client_name'] as String?,
      email_address: json['email_address'] as String?,
      contact_no: json['contact_no'] as String?,
      username: json['username'] as String?,
      email_notification: json['email_notification'] as String?,
      user_type: json['user_type'] as String?,
      is_active: json['is_active'] as String?,
    );

Map<String, dynamic> _$EditClientUserToJson(EditClientUser instance) =>
    <String, dynamic>{
      'client_user_id': instance.client_user_id,
      'client_name': instance.client_name,
      'email_address': instance.email_address,
      'contact_no': instance.contact_no,
      'username': instance.username,
      'email_notification': instance.email_notification,
      'user_type': instance.user_type,
      'is_active': instance.is_active,
    };
