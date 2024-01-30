// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommentData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentData _$CommentDataFromJson(Map<String, dynamic> json) => CommentData(
      id: json['id'] as String?,
      park_id: json['park_id'] as String?,
      park_name: json['park_name'] as String?,
      user_name: json['user_name'] as String?,
      description: json['description'] as String?,
      email_address: json['email_address'] as String?,
      recommend: json['recommend'] as String?,
      rating: json['rating'] as String?,
      status: json['status'] as String?,
      assigned_by: json['assigned_by'] as String?,
      assigned_to: json['assigned_to'] as String?,
      add_date: json['add_date'] as String?,
    );

Map<String, dynamic> _$CommentDataToJson(CommentData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'park_id': instance.park_id,
      'park_name': instance.park_name,
      'user_name': instance.user_name,
      'description': instance.description,
      'email_address': instance.email_address,
      'recommend': instance.recommend,
      'rating': instance.rating,
      'status': instance.status,
      'assigned_by': instance.assigned_by,
      'assigned_to': instance.assigned_to,
      'add_date': instance.add_date,
    };
