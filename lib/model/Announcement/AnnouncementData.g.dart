// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AnnouncementData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnouncementData _$AnnouncementDataFromJson(Map<String, dynamic> json) =>
    AnnouncementData(
      id: json['id'] as String?,
      client_id: json['client_id'] as String?,
      client_user_id: json['client_user_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      annoucement_lang_cols:
          (json['annoucement_lang_cols'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, AnnouncementDetailLangWise.fromJson(e as Map<String, dynamic>)),
      ),
      created_at: json['created_at'] as String?,
    )
      ..status = json['status']
      ..msg = json['msg'] as String?
      ..park_id = json['park_id']
      ..trail_id = json['trail_id'];

Map<String, dynamic> _$AnnouncementDataToJson(AnnouncementData instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'park_id': instance.park_id,
      'trail_id': instance.trail_id,
      'id': instance.id,
      'client_id': instance.client_id,
      'client_user_id': instance.client_user_id,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
      'annoucement_lang_cols': instance.annoucement_lang_cols,
      'created_at': instance.created_at,
    };
