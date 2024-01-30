import 'package:json_annotation/json_annotation.dart';

part 'CommentData.g.dart';

@JsonSerializable()
class CommentData {
  String? id;
  String? park_id;
  String? park_name;
  String? user_name;
  String? description;
  String? email_address;
  String? recommend;
  String? rating;
  String? status;
  String? assigned_by;
  String? assigned_to;
  String? add_date;

  CommentData(
      {this.id,
      this.park_id,
      this.park_name,
      this.user_name,
      this.description,
      this.email_address,
      this.recommend,
      this.rating,
      this.status,
      this.assigned_by,
      this.assigned_to,
      this.add_date});

  factory CommentData.fromJson(Map<String, dynamic> json) =>
      _$CommentDataFromJson(json);

  Map<String, dynamic> toJson() => _$CommentDataToJson(this);
}
