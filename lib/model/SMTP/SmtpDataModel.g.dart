// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SmtpDataModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmtpDataModel _$SmtpDataModelFromJson(Map<String, dynamic> json) =>
    SmtpDataModel(
      smtpHost: json['smtpHost'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      port: json['port'] as String?,
      fromEmail: json['fromEmail'] as String?,
      smtpSecurity: json['smtpSecurity'] as String?,
    );

Map<String, dynamic> _$SmtpDataModelToJson(SmtpDataModel instance) =>
    <String, dynamic>{
      'smtpHost': instance.smtpHost,
      'email': instance.email,
      'username': instance.username,
      'password': instance.password,
      'port': instance.port,
      'fromEmail': instance.fromEmail,
      'smtpSecurity': instance.smtpSecurity,
    };
