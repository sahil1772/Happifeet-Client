// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BaseResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) => BaseResponse(
      status: json['status'],
      msg: json['msg'] as String?,
      park_id: json['park_id'],
      trail_id: json['trail_id'],
    );

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'park_id': instance.park_id,
      'trail_id': instance.trail_id,
    };
