import 'package:json_annotation/json_annotation.dart';

part 'LocationDataModel.g.dart';

@JsonSerializable()
class LocationDataModel {
  // String? park_id;
  // String? park_name;
  // String? address;
  // String? city;
  // String? state;
  // String? description;
  // String? park_name_spa;
  // String? address_spa;
  // String? city_spa;
  // String? zip;
  // String? description_spa;
  // List? fuUpload;
  // String? main_loc;
  // double? latitude;
  // double? longitude;
  // String? reserve_link;
  // String? available;
  // List? monthChk;
  // List? features;
  // String? status;

  /** OLD **/

  String? id;
  String? locationName;
  String? addressStreet;
  String? city;
  String? state;
  String? street;
  String? zip;
  String? latitude;
  String? longitude;
  String? mainCityLocation;

  String? description;
  String? parkAvailability;
  String? startDate;
  String? endDate;
  String? reservationlink;
  String? status;
  List<String>? parkAvailabilityMonths;
  List<String?>? parkFeatures;
  List<String?>? otherFeatures;

  String? parkImages;
  List<String?>? galleryImages;

  LocationDataModel({
    // this.park_id,
    //     this.park_name,
    //     this.address,
    //     this.city,
    //     this.state,
    //     this.description,
    //     this.park_name_spa,
    //     this.address_spa,
    //     this.city_spa,
    //     this.zip,
    //     this.description_spa,
    //     this.fuUpload,
    //     this.main_loc,
    //     this.latitude,
    //     this.longitude,
    //     this.reserve_link,
    //     this.available,
    //     this.monthChk,
    //     this.features,
    //     this.status

    this.id,
    this.locationName,
    this.addressStreet,
    this.city,
    this.state,
    this.zip,
    this.latitude,
    this.longitude,
    this.mainCityLocation,
    this.description,
    this.parkAvailability,
    this.startDate,
    this.endDate,
    this.parkAvailabilityMonths,
    this.parkFeatures,
    this.reservationlink,
    this.status,
    this.otherFeatures,
    this.parkImages,
    this.galleryImages,

    //
  });

  factory LocationDataModel.fromJson(Map<String, dynamic> json) =>
      _$LocationDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDataModelToJson(this);
}
