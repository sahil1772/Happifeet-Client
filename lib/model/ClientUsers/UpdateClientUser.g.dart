// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UpdateClientUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateClientUser _$UpdateClientUserFromJson(Map<String, dynamic> json) =>
    UpdateClientUser(
      id: json['id'] as String?,
      user_id: json['user_id'] as String?,
      client_name: json['client_name'] as String?,
      email_address: json['email_address'] as String?,
      contact_no: json['contact_no'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      email_notifiction: json['email_notifiction'] as String?,
      user_type: json['user_type'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$UpdateClientUserToJson(UpdateClientUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'client_name': instance.client_name,
      'email_address': instance.email_address,
      'contact_no': instance.contact_no,
      'username': instance.username,
      'password': instance.password,
      'email_notifiction': instance.email_notifiction,
      'user_type': instance.user_type,
      'status': instance.status,
    };
