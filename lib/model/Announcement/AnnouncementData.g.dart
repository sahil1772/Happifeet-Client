// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AnnouncementData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnouncementData _$AnnouncementDataFromJson(Map<String, dynamic> json) =>
    AnnouncementData(
      user_id: json['user_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      filename: json['filename'] as String?,
      tmpfilename: json['tmpfilename'] as String?,
    );

Map<String, dynamic> _$AnnouncementDataToJson(AnnouncementData instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'title': instance.title,
      'description': instance.description,
      'filename': instance.filename,
      'tmpfilename': instance.tmpfilename,
    };
