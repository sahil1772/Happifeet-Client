


import 'package:json_annotation/json_annotation.dart';

part 'LocationData.g.dart';

@JsonSerializable()

class LocationData{
  String? park_id;
  String? park_name;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? zip;
  String? description;
  String? image;
  String? qrImage;

  LocationData({
    this.park_id,
    this.park_name,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.zip,
    this.description,
    this.image,
    this.qrImage,

});

  factory LocationData.fromJson(Map<String, dynamic> json) =>
      _$LocationDataFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDataToJson(this);
}