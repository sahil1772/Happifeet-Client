


import 'package:json_annotation/json_annotation.dart';

part 'SmtpDetails.g.dart';

@JsonSerializable()


class SmtpDetails {
  String? id;
  String? smtp_host;
  String? email_from_name;
  String? smtp_username;
  String? smtp_password;
  String? smtp_port;
  String? from_email_id;
  String? smtp_security;
  String? is_active;


SmtpDetails({
  this.id,
this.smtp_host,
  this.email_from_name,
  this.smtp_username,
  this.smtp_password,
  this.smtp_port,
  this.from_email_id,
  this.smtp_security,
  this.is_active


});

  factory SmtpDetails.fromJson(Map<String, dynamic> json) =>
      _$SmtpDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$SmtpDetailsToJson(this);


}