import 'package:image_picker/image_picker.dart';
import 'package:json_annotation/json_annotation.dart';

part 'TrailPayload.g.dart';

@JsonSerializable()
class TrailPayload {
  String? lang;
  String? trail_id;
  String? trailName;
  String? trailDescription;
  String? trailDistance;
  String? trailDifficulty;
  String? trailOpeningTime;
  String? trailOpeningTime2;
  String? status;
  String? trailImages;
  List<String>? trailDetailImages;


  TrailPayload(
      {this.lang,
      this.trailName,
      this.trail_id,
      this.trailDescription,
      this.trailDistance,
      this.trailDifficulty,
      this.trailOpeningTime,
      this.status,
      this.trailImages,
      this.trailDetailImages,
      this.trailOpeningTime2});


  factory TrailPayload.fromJson(Map<String, dynamic> json) =>
      _$TrailPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$TrailPayloadToJson(this);
}
