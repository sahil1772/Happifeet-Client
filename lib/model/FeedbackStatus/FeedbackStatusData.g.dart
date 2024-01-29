// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FeedbackStatusData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackStatusData _$FeedbackStatusDataFromJson(Map<String, dynamic> json) =>
    FeedbackStatusData(
      id: json['id'] as String?,
      park_id: json['park_id'] as String?,
      park_name: json['park_name'] as String?,
      diff_cnt: json['diff_cnt'] as String?,
      description: json['description'] as String?,
      new_date: json['new_date'] as String?,
      status: json['status'] as String?,
      assigned_by: json['assigned_by'] as String?,
      assigned_to: json['assigned_to'] as String?,
      add_date: json['add_date'] as String?,
    );

Map<String, dynamic> _$FeedbackStatusDataToJson(FeedbackStatusData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'park_id': instance.park_id,
      'park_name': instance.park_name,
      'diff_cnt': instance.diff_cnt,
      'description': instance.description,
      'new_date': instance.new_date,
      'status': instance.status,
      'assigned_by': instance.assigned_by,
      'assigned_to': instance.assigned_to,
      'add_date': instance.add_date,
    };
