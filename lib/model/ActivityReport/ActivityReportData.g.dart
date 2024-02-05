// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ActivityReportData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityReportData _$ActivityReportDataFromJson(Map<String, dynamic> json) =>
    ActivityReportData(
      id: json['id'] as String?,
      park_id: json['park_id'] as String?,
      park_name: json['park_name'] as String?,
      feedback: json['feedback'] as String?,
      photo_gallary: json['photo_gallary'] as String?,
      detail: json['detail'] as String?,
      reservation: json['reservation'] as String?,
      know_more: json['know_more'] as String?,
      add_date: json['add_date'] as String?,
    );

Map<String, dynamic> _$ActivityReportDataToJson(ActivityReportData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'park_id': instance.park_id,
      'park_name': instance.park_name,
      'feedback': instance.feedback,
      'photo_gallary': instance.photo_gallary,
      'detail': instance.detail,
      'reservation': instance.reservation,
      'know_more': instance.know_more,
      'add_date': instance.add_date,
    };
