





import 'package:json_annotation/json_annotation.dart';

part 'SubmitAssignedUserData.g.dart';

@JsonSerializable()

class SubmitAssignedUserData{
 String? user_id;
 String? client_name;
 String? contact_no;
 String? email_address;
 String? note;
 String? status;



  SubmitAssignedUserData({
  this.user_id,
    this.client_name,
    this.contact_no,
    this.email_address,
    this.note,
    this.status


  });

  factory SubmitAssignedUserData.fromJson(Map<String, dynamic> json) =>
      _$SubmitAssignedUserDataFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitAssignedUserDataToJson(this);
}