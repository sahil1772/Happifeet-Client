
import 'package:json_annotation/json_annotation.dart';

part 'LocationFeedback.g.dart';

@JsonSerializable()
class LocationFeedback{

  String? park_name;
  String? feedback_count;
  String? report_id;
  String? user_name;
  String? address;
  String? description;
  String? rating;
  String? recommend;
  String? add_date;


  LocationFeedback(
      {this.park_name,
      this.feedback_count,
      this.report_id,
      this.user_name,
      this.address,
      this.description,
      this.rating,
      this.recommend,
      this.add_date});

  factory LocationFeedback.fromJson(Map<String, dynamic> json) =>
      _$LocationFeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$LocationFeedbackToJson(this);
}