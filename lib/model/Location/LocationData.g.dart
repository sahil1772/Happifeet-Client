// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocationData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationData _$LocationDataFromJson(Map<String, dynamic> json) => LocationData(
      park_id: json['park_id'] as String?,
      park_name: json['park_name'] as String?,
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zip: json['zip'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      qr_image: json['qr_image'] as String?,
    );

Map<String, dynamic> _$LocationDataToJson(LocationData instance) =>
    <String, dynamic>{
      'park_id': instance.park_id,
      'park_name': instance.park_name,
      'address1': instance.address1,
      'address2': instance.address2,
      'city': instance.city,
      'state': instance.state,
      'zip': instance.zip,
      'description': instance.description,
      'image': instance.image,
      'qr_image': instance.qr_image,
    };
