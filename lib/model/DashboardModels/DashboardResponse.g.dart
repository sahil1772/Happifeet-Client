// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DashboardResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardResponse _$DashboardResponseFromJson(Map<String, dynamic> json) =>
    DashboardResponse(
      commentsGraph: json['commentsGraph'],
      ratingGraph: json['ratingGraph'],
      recommendGraph: json['recommendGraph'],
      location_feedback_count: json['location_feedback_count'],
      feedback_list: json['feedback_list'],
    );

Map<String, dynamic> _$DashboardResponseToJson(DashboardResponse instance) =>
    <String, dynamic>{
      'commentsGraph': instance.commentsGraph,
      'ratingGraph': instance.ratingGraph,
      'recommendGraph': instance.recommendGraph,
      'location_feedback_count': instance.location_feedback_count,
      'feedback_list': instance.feedback_list,
    };
