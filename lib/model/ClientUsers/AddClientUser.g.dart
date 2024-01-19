// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AddClientUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddClientUser _$AddClientUserFromJson(Map<String, dynamic> json) =>
    AddClientUser(
      user_id: json['user_id'] as String?,
      client_name: json['client_name'] as String?,
      email_address: json['email_address'] as String?,
      contact_no: json['contact_no'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      email_notification: json['email_notification'] as String?,
      user_type: json['user_type'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$AddClientUserToJson(AddClientUser instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'client_name': instance.client_name,
      'email_address': instance.email_address,
      'contact_no': instance.contact_no,
      'username': instance.username,
      'password': instance.password,
      'email_notification': instance.email_notification,
      'user_type': instance.user_type,
      'status': instance.status,
    };
