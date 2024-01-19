// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SmtpDetails.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmtpDetails _$SmtpDetailsFromJson(Map<String, dynamic> json) => SmtpDetails(
      id: json['id'] as String?,
      smtp_host: json['smtp_host'] as String?,
      email_from_name: json['email_from_name'] as String?,
      smtp_username: json['smtp_username'] as String?,
      smtp_password: json['smtp_password'] as String?,
      smtp_port: json['smtp_port'] as String?,
      from_email_id: json['from_email_id'] as String?,
      smtp_security: json['smtp_security'] as String?,
      is_active: json['is_active'] as String?,
    );

Map<String, dynamic> _$SmtpDetailsToJson(SmtpDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'smtp_host': instance.smtp_host,
      'email_from_name': instance.email_from_name,
      'smtp_username': instance.smtp_username,
      'smtp_password': instance.smtp_password,
      'smtp_port': instance.smtp_port,
      'from_email_id': instance.from_email_id,
      'smtp_security': instance.smtp_security,
      'is_active': instance.is_active,
    };
