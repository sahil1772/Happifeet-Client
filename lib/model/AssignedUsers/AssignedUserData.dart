



import 'package:json_annotation/json_annotation.dart';

part 'AssignedUserData.g.dart';

@JsonSerializable()

class AssignedUserData{
  String? client_name;
  String? number;
  String? email_address;
  String? noteremark;
  String? status;



AssignedUserData({
    this.client_name,
  this.number,
  this.email_address,
  this.noteremark,
  this.status


});

factory AssignedUserData.fromJson(Map<String, dynamic> json) =>
_$AssignedUserDataFromJson(json);

Map<String, dynamic> toJson() => _$AssignedUserDataToJson(this);
}