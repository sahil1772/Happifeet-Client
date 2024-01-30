

import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

import 'CommentsData.dart';

part 'FeedbackStatusDetails.g.dart';

@JsonSerializable()
class FeedbackStatusDetails{
  String? park_id;
  String? park_name;
  String? user_name;
  String? email_address;
  String? anonymous_user;
  String? send_updates;
  String? lat;
  String? longi;
  String? user_location;
  String? rating;
  String? recommend;
  String? descrpt;
  String? how_safe_feel;
  String? zip_code_live;
  List<CommentsData>? comment;


  FeedbackStatusDetails(
      {this.park_id,
      this.park_name,
      this.user_name,
      this.email_address,
      this.anonymous_user,
      this.send_updates,
      this.lat,
      this.longi,
      this.user_location,
      this.rating,
      this.recommend,
      this.descrpt,
      this.how_safe_feel,
      this.zip_code_live,
      this.comment});

  factory FeedbackStatusDetails.fromJson(Map<String, dynamic> json) =>
      _$FeedbackStatusDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackStatusDetailsToJson(this);


}

