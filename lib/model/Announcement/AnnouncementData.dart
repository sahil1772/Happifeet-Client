

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part 'AnnouncementData.g.dart';

@JsonSerializable()


class AnnouncementData{

  String? user_id;
  String? title;
  String? description;
  String? filename;
  String? tmpfilename;

  AnnouncementData({
    this.user_id,
    this.title,
    this.description,
    this.filename,
    this.tmpfilename
});

  factory AnnouncementData.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementDataFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementDataToJson(this);

}