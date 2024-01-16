import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

part 'DashboardResponse.g.dart';

@JsonSerializable()
class DashboardResponse {

  dynamic? commentsGraph;
  dynamic? ratingGraph;
  dynamic? recommendGraph;
  dynamic? location_feedback_count;
  dynamic? feedback_list;

  DashboardResponse(
      {this.commentsGraph,
      this.ratingGraph,
      this.recommendGraph,
      this.location_feedback_count,
      this.feedback_list});

  factory DashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$DashboardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardResponseToJson(this);
}
