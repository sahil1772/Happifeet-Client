// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BaseResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) => BaseResponse(
      status: json['status'],
      msg: json['msg'] as String?,
    );

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
    };
