// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AssignedUserData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssignedUserData _$AssignedUserDataFromJson(Map<String, dynamic> json) =>
    AssignedUserData(
      client_name: json['client_name'] as String?,
      number: json['number'] as String?,
      email_address: json['email_address'] as String?,
      noteremark: json['noteremark'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$AssignedUserDataToJson(AssignedUserData instance) =>
    <String, dynamic>{
      'client_name': instance.client_name,
      'number': instance.number,
      'email_address': instance.email_address,
      'noteremark': instance.noteremark,
      'status': instance.status,
    };
