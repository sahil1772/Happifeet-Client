// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AccessPermissionData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessPermissionData _$AccessPermissionDataFromJson(
        Map<String, dynamic> json) =>
    AccessPermissionData(
      announcement: json['announcement'] as String?,
      park_inspection: json['park_inspection'] as String?,
      activity_report: json['activity_report'] as String?,
      trail: json['trail'] as String?,
    );

Map<String, dynamic> _$AccessPermissionDataToJson(
        AccessPermissionData instance) =>
    <String, dynamic>{
      'announcement': instance.announcement,
      'park_inspection': instance.park_inspection,
      'activity_report': instance.activity_report,
      'trail': instance.trail,
    };
