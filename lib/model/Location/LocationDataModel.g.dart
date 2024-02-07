// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocationDataModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationDataModel _$LocationDataModelFromJson(Map<String, dynamic> json) =>
    LocationDataModel(
      id: json['id'] as String?,
      locationName: json['locationName'] as String?,
      addressStreet: json['addressStreet'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zip: json['zip'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      mainCityLocation: json['mainCityLocation'] as String?,
      description: json['description'] as String?,
      parkAvailability: json['parkAvailability'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      parkAvailabilityMonths: (json['parkAvailabilityMonths'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      parkFeatures: (json['parkFeatures'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      reservationlink: json['reservationlink'] as String?,
      status: json['status'] as String?,
      otherFeatures: (json['otherFeatures'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      parkImages: json['parkImages'] as String?,
      galleryImages: (json['galleryImages'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
    )..street = json['street'] as String?;

Map<String, dynamic> _$LocationDataModelToJson(LocationDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'locationName': instance.locationName,
      'addressStreet': instance.addressStreet,
      'city': instance.city,
      'state': instance.state,
      'street': instance.street,
      'zip': instance.zip,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'mainCityLocation': instance.mainCityLocation,
      'description': instance.description,
      'parkAvailability': instance.parkAvailability,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'reservationlink': instance.reservationlink,
      'status': instance.status,
      'parkAvailabilityMonths': instance.parkAvailabilityMonths,
      'parkFeatures': instance.parkFeatures,
      'otherFeatures': instance.otherFeatures,
      'parkImages': instance.parkImages,
      'galleryImages': instance.galleryImages,
    };
