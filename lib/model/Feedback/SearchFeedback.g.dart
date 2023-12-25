// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SearchFeedback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchFeedback _$SearchFeedbackFromJson(Map<String, dynamic> json) =>
    SearchFeedback(
      type: json['type'] as String?,
      srchFromDate: json['srchFromDate'] as String?,
      srchToDate: json['srchToDate'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$SearchFeedbackToJson(SearchFeedback instance) =>
    <String, dynamic>{
      'type': instance.type,
      'srchFromDate': instance.srchFromDate,
      'srchToDate': instance.srchToDate,
      'status': instance.status,
    };
