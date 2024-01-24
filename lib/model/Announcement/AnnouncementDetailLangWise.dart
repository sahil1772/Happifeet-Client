import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'AnnouncementDetailLangWise.g.dart';

@JsonSerializable()
class AnnouncementDetailLangWise {
String? title;
String? description;


AnnouncementDetailLangWise({this.title, this.description});

  factory AnnouncementDetailLangWise.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementDetailLangWiseFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementDetailLangWiseToJson(this);
}
