import 'dart:convert';

import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:json_annotation/json_annotation.dart';


part 'ActivityReportData.g.dart';

@JsonSerializable()
class ActivityReportData {

  String? id;
  String? park_id;
  String? park_name;
  String? feedback;
  String? photo_gallary;
  String? detail;
  String? reservation;
  String? know_more;
  String? add_date;


  ActivityReportData(
      {this.id,
      this.park_id,
      this.park_name,
      this.feedback,
      this.photo_gallary,
      this.detail,
      this.reservation,
      this.know_more,
      this.add_date});

  factory ActivityReportData.fromJson(Map<String, dynamic> json) =>
      _$ActivityReportDataFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityReportDataToJson(this);
}
