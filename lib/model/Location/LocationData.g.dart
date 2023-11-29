// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocationData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationData _$LocationDataFromJson(Map<String, dynamic> json) => LocationData(
      language: json['language'] as String?,
      clientName: json['clientName'] as String?,
      mainSite: json['mainSite'] as String?,
      locationName: json['locationName'] as String?,
      addressStreet: json['addressStreet'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zip: json['zip'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      mainCityLocation: json['mainCityLocation'] as String?,
      parkImages: (json['parkImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      galleryImages: (json['galleryImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
      parkAvailability: json['parkAvailability'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      parkAvailabilityMonths: (json['parkAvailabilityMonths'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      parkFeatures: (json['parkFeatures'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      otherLanguages: (json['otherLanguages'] as List<dynamic>?)
          ?.map((e) => LocationData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationDataToJson(LocationData instance) =>
    <String, dynamic>{
      'language': instance.language,
      'clientName': instance.clientName,
      'mainSite': instance.mainSite,
      'locationName': instance.locationName,
      'addressStreet': instance.addressStreet,
      'city': instance.city,
      'state': instance.state,
      'zip': instance.zip,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'mainCityLocation': instance.mainCityLocation,
      'parkImages': instance.parkImages,
      'galleryImages': instance.galleryImages,
      'description': instance.description,
      'parkAvailability': instance.parkAvailability,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'parkAvailabilityMonths': instance.parkAvailabilityMonths,
      'parkFeatures': instance.parkFeatures,
      'otherLanguages': instance.otherLanguages,
    };
