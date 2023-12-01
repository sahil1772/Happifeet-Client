

import 'package:json_annotation/json_annotation.dart';

part 'SmtpDataModel.g.dart';

@JsonSerializable()




class SmtpDataModel {

  String? smtpHost;
  String? email;
  String? username;
  String? password;
  String? port;
  String? fromEmail;
  String? smtpSecurity;

  SmtpDataModel(
  {
    this.smtpHost,
    this.email,
    this.username,
    this.password,
    this.port,
    this.fromEmail,
    this.smtpSecurity


});

  factory SmtpDataModel.fromJson(Map<String, dynamic> json) =>
      _$SmtpDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SmtpDataModelToJson(this);

}