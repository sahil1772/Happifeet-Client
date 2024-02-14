import 'package:json_annotation/json_annotation.dart';

part 'BaseResponse.g.dart';

@JsonSerializable()
class BaseResponse {
  dynamic status;
  String? msg;
  String? exportUrl;
  dynamic park_id;
  dynamic trail_id;

  BaseResponse({this.status, this.msg, this.park_id, this.trail_id,this.exportUrl});

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}
