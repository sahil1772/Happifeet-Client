

import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'FeedbackStatusData.g.dart';

@JsonSerializable()
class FeedbackStatusData{
  String? id;
  String? park_id;
  String? park_name;
  String? diff_cnt;
  String? description;
  String? new_date;
  String? status;
  String? assigned_by;
  String? assigned_to;
  String? add_date;
  String? added_by_name;
  String? assigned_to_name;

  FeedbackStatusData(
      {this.id,
      this.park_id,
      this.park_name,
      this.diff_cnt,
      this.description,
      this.new_date,
      this.status,
      this.assigned_by,
      this.assigned_to,
      this.add_date,
      this.added_by_name,
      this.assigned_to_name});

  factory FeedbackStatusData.fromJson(Map<String, dynamic> json) =>
      _$FeedbackStatusDataFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackStatusDataToJson(this);


}

