



import 'package:json_annotation/json_annotation.dart';

part 'FeedbackData.g.dart';

@JsonSerializable()

class FeedbackData{

  String? user_id;
  String? type;
  String? main_location;

  FeedbackData({
    this.user_id,
    this.type,
    this.main_location
});

  factory FeedbackData.fromJson(Map<String, dynamic> json) =>
      _$FeedbackDataFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackDataToJson(this);

}