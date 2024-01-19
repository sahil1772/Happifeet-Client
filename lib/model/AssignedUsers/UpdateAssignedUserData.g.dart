// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UpdateAssignedUserData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateAssignedUserData _$UpdateAssignedUserDataFromJson(
        Map<String, dynamic> json) =>
    UpdateAssignedUserData(
      user_id: json['user_id'] as String?,
      id: json['id'] as String?,
      client_name: json['client_name'] as String?,
      contact_no: json['contact_no'] as String?,
      email_address: json['email_address'] as String?,
      note: json['note'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$UpdateAssignedUserDataToJson(
        UpdateAssignedUserData instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'id': instance.id,
      'client_name': instance.client_name,
      'contact_no': instance.contact_no,
      'email_address': instance.email_address,
      'note': instance.note,
      'status': instance.status,
    };
