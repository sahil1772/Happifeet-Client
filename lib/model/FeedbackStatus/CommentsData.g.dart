// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommentsData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentsData _$CommentsDataFromJson(Map<String, dynamic> json) => CommentsData(
      id: json['id'] as String?,
      comment: json['comment'] as String?,
      status: json['status'] as String?,
      added_date: json['added_date'] as String?,
      assign_by: json['assign_by'] as String?,
      assign_to: json['assign_to'] as String?,
      images_uploaded: (json['images_uploaded'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CommentsDataToJson(CommentsData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'status': instance.status,
      'added_date': instance.added_date,
      'assign_by': instance.assign_by,
      'assign_to': instance.assign_to,
      'images_uploaded': instance.images_uploaded,
    };
