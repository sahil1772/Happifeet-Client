

import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'CommentsData.g.dart';

@JsonSerializable()
class CommentsData{
  String? id;
  String? comment;
  String? status;
  String? added_date;
  String? assign_by;
  String? assign_to;
  List<String>? images_uploaded;


  CommentsData(
      {this.id,
      this.comment,
      this.status,
      this.added_date,
      this.assign_by,
      this.assign_to,
      this.images_uploaded});

  factory CommentsData.fromJson(Map<String, dynamic> json) =>
      _$CommentsDataFromJson(json);

  Map<String, dynamic> toJson() => _$CommentsDataToJson(this);


}

