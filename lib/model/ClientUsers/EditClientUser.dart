

import 'package:json_annotation/json_annotation.dart';

part 'EditClientUser.g.dart';

@JsonSerializable()
class EditClientUser {
  String? client_user_id;
  String? client_name;
  String? email_address;
  String? contact_no;
  String? username;
  String? email_notification;
  String? user_type;
  String? is_active;

  EditClientUser(
      {this.client_user_id,
      this.client_name,
      this.email_address,
      this.contact_no,
      this.username,
      this.email_notification,
      this.user_type,
      this.is_active});


  factory EditClientUser.fromJson(Map<String, dynamic> json) =>
      _$EditClientUserFromJson(json);

  Map<String, dynamic> toJson() => _$EditClientUserToJson(this);
}
