// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MailLogData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MailLogData _$MailLogDataFromJson(Map<String, dynamic> json) => MailLogData(
      subject: json['subject'] as String?,
      comment: json['comment'] as String?,
      add_date: json['add_date'] as String?,
    );

Map<String, dynamic> _$MailLogDataToJson(MailLogData instance) =>
    <String, dynamic>{
      'subject': instance.subject,
      'comment': instance.comment,
      'add_date': instance.add_date,
    };
