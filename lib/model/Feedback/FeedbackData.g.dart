// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FeedbackData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackData _$FeedbackDataFromJson(Map<String, dynamic> json) => FeedbackData(
      user_id: json['user_id'] as String?,
      type: json['type'] as String?,
      main_location: json['main_location'] as String?,
    );

Map<String, dynamic> _$FeedbackDataToJson(FeedbackData instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'type': instance.type,
      'main_location': instance.main_location,
    };
