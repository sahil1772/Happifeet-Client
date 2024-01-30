
import 'package:json_annotation/json_annotation.dart';

import 'AccessPermissionData.dart';

part 'UserData.g.dart';

@JsonSerializable()


class UserData {
  String? parent_user_id;
  String? user_id;
  String? user_name;
  String? user_type;
  String? client_id;
  AccessPermissionData? access;
  Map<String,dynamic>? language;
  Map<String, dynamic>? theme_data;

  UserData({
    this.parent_user_id,
    this.user_id,
    this.user_name,
    this.user_type,
    this.client_id,
    this.access,
    this.language,
    this.theme_data

  });

  factory UserData.fromJson(Map<String,dynamic> json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);



}