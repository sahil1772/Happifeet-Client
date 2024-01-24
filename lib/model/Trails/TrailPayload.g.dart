// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TrailPayload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrailPayload _$TrailPayloadFromJson(Map<String, dynamic> json) => TrailPayload(
      lang: json['lang'] as String?,
      trailName: json['trailName'] as String?,
      trail_id: json['trail_id'] as String?,
      trailDescription: json['trailDescription'] as String?,
      trailDistance: json['trailDistance'] as String?,
      trailDifficulty: json['trailDifficulty'] as String?,
      trailOpeningTime: json['trailOpeningTime'] as String?,
      status: json['status'] as String?,
      trailOpeningTime2: json['trailOpeningTime2'] as String?,
    );

Map<String, dynamic> _$TrailPayloadToJson(TrailPayload instance) =>
    <String, dynamic>{
      'lang': instance.lang,
      'trail_id': instance.trail_id,
      'trailName': instance.trailName,
      'trailDescription': instance.trailDescription,
      'trailDistance': instance.trailDistance,
      'trailDifficulty': instance.trailDifficulty,
      'trailOpeningTime': instance.trailOpeningTime,
      'trailOpeningTime2': instance.trailOpeningTime2,
      'status': instance.status,
    };
