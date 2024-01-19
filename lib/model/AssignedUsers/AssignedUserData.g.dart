// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AssignedUserData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssignedUserData _$AssignedUserDataFromJson(Map<String, dynamic> json) =>
    AssignedUserData(
      id: json['id'] as String?,
      name: json['name'] as String?,
      contactno: json['contactno'] as String?,
      emailid: json['emailid'] as String?,
      note_remark: json['note_remark'] as String?,
      is_active: json['is_active'] as String?,
    );

Map<String, dynamic> _$AssignedUserDataToJson(AssignedUserData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'contactno': instance.contactno,
      'emailid': instance.emailid,
      'note_remark': instance.note_remark,
      'is_active': instance.is_active,
    };
