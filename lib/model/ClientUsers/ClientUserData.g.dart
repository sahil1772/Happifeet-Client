// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClientUserData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientUserData _$ClientUserDataFromJson(Map<String, dynamic> json) =>
    ClientUserData(
      id: json['id'] as String?,
      client_name: json['client_name'] as String?,
      email_address: json['email_address'] as String?,
      contact_no: json['contact_no'] as String?,
      username: json['username'] as String?,
      user_type: json['user_type'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$ClientUserDataToJson(ClientUserData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client_name': instance.client_name,
      'email_address': instance.email_address,
      'contact_no': instance.contact_no,
      'username': instance.username,
      'user_type': instance.user_type,
      'status': instance.status,
    };
