

import 'package:json_annotation/json_annotation.dart';

part 'SmtpDataModel.g.dart';

@JsonSerializable()




class SmtpDataModel {

  String? client_id;
  String? smtp_host;
  String? email_from_name;
  String? smtp_username;
  String? smtp_password;
  String? smtp_port;
  String? from_email_id;
  String? smtp_security;

  SmtpDataModel(
  {
 this.client_id,
    this.smtp_host,
    this.email_from_name,
    this.smtp_username,
    this.smtp_password,
    this.smtp_port,
    this.from_email_id,
    this.smtp_security


});

  factory SmtpDataModel.fromJson(Map<String, dynamic> json) =>
      _$SmtpDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SmtpDataModelToJson(this);

}