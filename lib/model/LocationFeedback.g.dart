// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocationFeedback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationFeedback _$LocationFeedbackFromJson(Map<String, dynamic> json) =>
    LocationFeedback(
      park_name: json['park_name'] as String?,
      feedback_count: json['feedback_count'] as String?,
      report_id: json['report_id'] as String?,
      user_name: json['user_name'] as String?,
      address: json['address'] as String?,
      description: json['description'] as String?,
      rating: json['rating'] as String?,
      recommend: json['recommend'] as String?,
      add_date: json['add_date'] as String?,
    );

Map<String, dynamic> _$LocationFeedbackToJson(LocationFeedback instance) =>
    <String, dynamic>{
      'park_name': instance.park_name,
      'feedback_count': instance.feedback_count,
      'report_id': instance.report_id,
      'user_name': instance.user_name,
      'address': instance.address,
      'description': instance.description,
      'rating': instance.rating,
      'recommend': instance.recommend,
      'add_date': instance.add_date,
    };
