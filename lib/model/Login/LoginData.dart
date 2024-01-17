
import 'package:json_annotation/json_annotation.dart';

import 'UserData.dart';

part 'LoginData.g.dart';

@JsonSerializable()


class LoginData {
String? status;
String? msg;
UserData? data;
  LoginData({
this.status,
    this.msg,
    this.data
});

factory LoginData.fromJson(Map<String,dynamic> json) => _$LoginDataFromJson(json);

Map<String, dynamic> toJson() => _$LoginDataToJson(this);



}