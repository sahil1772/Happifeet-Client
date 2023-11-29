import 'package:json_annotation/json_annotation.dart';

part 'LocationData.g.dart';

@JsonSerializable()
class LocationData {
  String? language;
  String? clientName;
  String? mainSite;
  String? locationName;
  String? addressStreet;
  String? city;
  String? state;
  String? zip;
  String? latitude;
  String? longitude;
  String? mainCityLocation;
  List<String>? parkImages;
  List<String>? galleryImages;

  String? description;

  String? parkAvailability;
  String? startDate;
  String? endDate;
  List<String>? parkAvailabilityMonths;

  List<String>? parkFeatures;

  List<LocationData>? otherLanguages;


  LocationData(
      {required this.language,
      this.clientName,
      this.mainSite,
      this.locationName,
      this.addressStreet,
      this.city,
      this.state,
      this.zip,
      this.latitude,
      this.longitude,
      this.mainCityLocation,
      this.parkImages,
      this.galleryImages,
      this.description,
      this.parkAvailability,
      this.startDate,
      this.endDate,
      this.parkAvailabilityMonths,
      this.parkFeatures,
      this.otherLanguages});

  factory LocationData.fromJson(Map<String, dynamic> json) =>
      _$LocationDataFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDataToJson(this);
}
