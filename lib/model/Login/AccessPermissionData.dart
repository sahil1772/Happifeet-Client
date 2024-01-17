
import 'package:json_annotation/json_annotation.dart';

part 'AccessPermissionData.g.dart';

@JsonSerializable()


class AccessPermissionData {
  String? announcement;
  String? park_inspection;
  String? activity_report;
  String? trail;


  AccessPermissionData({
    this.announcement,
    this.park_inspection,
    this.activity_report,
    this.trail

  });

  factory AccessPermissionData.fromJson(Map<String,dynamic> json) => _$AccessPermissionDataFromJson(json);

  Map<String, dynamic> toJson() => _$AccessPermissionDataToJson(this);



}