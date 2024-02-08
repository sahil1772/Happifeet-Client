import 'package:image_picker/image_picker.dart';
import 'package:json_annotation/json_annotation.dart';

part 'TrailListingData.g.dart';

@JsonSerializable()
class TrailListingData {
  String? trail_id;
  String? trail_name;
  String? opening_time;
  String? opening_time2;
  String? distance;
  String? parkImages;

  TrailListingData(
      {this.trail_id,
      this.trail_name,
      this.opening_time,
      this.opening_time2,
      this.distance,
      this.parkImages});

  factory TrailListingData.fromJson(Map<String, dynamic> json) =>
      _$TrailListingDataFromJson(json);

  Map<String, dynamic> toJson() => _$TrailListingDataToJson(this);
}
