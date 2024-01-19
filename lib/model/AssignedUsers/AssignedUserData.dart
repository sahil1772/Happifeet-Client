





import 'package:json_annotation/json_annotation.dart';

part 'AssignedUserData.g.dart';

@JsonSerializable()

class AssignedUserData{
  String? id;
  String? name;
  String? contactno;
  String? emailid;
  String? note_remark;
  String? is_active;



AssignedUserData({
  this.id,
  this.name,
  this.contactno,
  this.emailid,
  this.note_remark,
  this.is_active


});

factory AssignedUserData.fromJson(Map<String, dynamic> json) =>
_$AssignedUserDataFromJson(json);

Map<String, dynamic> toJson() => _$AssignedUserDataToJson(this);

}