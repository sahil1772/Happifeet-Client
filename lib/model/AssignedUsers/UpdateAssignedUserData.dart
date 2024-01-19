
import 'package:json_annotation/json_annotation.dart';

part 'UpdateAssignedUserData.g.dart';

@JsonSerializable()

class UpdateAssignedUserData{
  String? user_id;
  String? id;
  String? client_name;
  String? contact_no;
  String? email_address;
  String? note;
  String? status;


  UpdateAssignedUserData({
    this.user_id,
    this.id,
    this.client_name,
    this.contact_no,
    this.email_address,
    this.note,
    this.status


  });

  factory UpdateAssignedUserData.fromJson(Map<String, dynamic> json) =>
      _$UpdateAssignedUserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateAssignedUserDataToJson(this);
}