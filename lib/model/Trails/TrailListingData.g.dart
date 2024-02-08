// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TrailListingData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrailListingData _$TrailListingDataFromJson(Map<String, dynamic> json) =>
    TrailListingData(
      trail_id: json['trail_id'] as String?,
      trail_name: json['trail_name'] as String?,
      opening_time: json['opening_time'] as String?,
      opening_time2: json['opening_time2'] as String?,
      distance: json['distance'] as String?,
      parkImages: json['parkImages'] as String?,
    );

Map<String, dynamic> _$TrailListingDataToJson(TrailListingData instance) =>
    <String, dynamic>{
      'trail_id': instance.trail_id,
      'trail_name': instance.trail_name,
      'opening_time': instance.opening_time,
      'opening_time2': instance.opening_time2,
      'distance': instance.distance,
      'parkImages': instance.parkImages,
    };
