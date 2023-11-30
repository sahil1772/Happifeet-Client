


import 'package:json_annotation/json_annotation.dart';

part 'LocationData.g.dart';

@JsonSerializable()

class LocationData{
  String? park_name;
  String? address;
  String? city;
  String? state;
  String? zip;
  String? description;
  LocationData({
    this.park_name,
    this.address,
    this.city,
    this.state,
    this.zip,
    this.description

});

  factory LocationData.fromJson(Map<String, dynamic> json) =>
      _$LocationDataFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDataToJson(this);
}