import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'AnnouncementDetailLangWise.dart';

part 'AnnouncementData.g.dart';

@JsonSerializable()
class AnnouncementData {
  String? id;
  String? client_id;
  String? client_user_id;
  String? title;
  String? description;
  String? image;
  Map<String,AnnouncementDetailLangWise>? annoucement_lang_cols;
  String? created_at;

  AnnouncementData(
      {this.id,
      this.client_id,
      this.client_user_id,
      this.title,
      this.description,
      this.image,
      this.annoucement_lang_cols,
      this.created_at});

  factory AnnouncementData.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementDataFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementDataToJson(this);
}
