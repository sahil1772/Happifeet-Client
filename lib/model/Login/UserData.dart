
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

  UserData({
    this.parent_user_id,
    this.user_id,
    this.user_name,
    this.user_type,
    this.client_id,
    this.access

  });

  factory UserData.fromJson(Map<String,dynamic> json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);



}