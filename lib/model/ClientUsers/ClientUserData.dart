





import 'package:json_annotation/json_annotation.dart';

part 'ClientUserData.g.dart';

@JsonSerializable()

class ClientUserData{
String? id;
String? client_name;
String? email_address;
String? contact_no;
String? username;
String? user_type;
String? status;



  ClientUserData({
    this.id,
    this.client_name,
    this.email_address,
    this.contact_no,
    this.username,
    this.user_type,
    this.status

  });

  factory ClientUserData.fromJson(Map<String, dynamic> json) =>
      _$ClientUserDataFromJson(json);

  Map<String, dynamic> toJson() => _$ClientUserDataToJson(this);

}