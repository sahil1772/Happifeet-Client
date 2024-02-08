

import 'package:json_annotation/json_annotation.dart';

part 'UpdateClientUser.g.dart';

@JsonSerializable()
class UpdateClientUser {
  String? id;
  String? user_id;
  String? client_name;
  String? email_address;
  String? contact_no;
  String? username;
  String? password;
  String? email_notification;
  String? user_type;
  String? status;


  UpdateClientUser(
      {this.id,
      this.user_id,
      this.client_name,
      this.email_address,
      this.contact_no,
      this.username,
      this.password,
      this.email_notification,
      this.user_type,
      this.status});

  factory UpdateClientUser.fromJson(Map<String, dynamic> json) =>
      _$UpdateClientUserFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateClientUserToJson(this);
}
