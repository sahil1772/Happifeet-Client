import 'package:json_annotation/json_annotation.dart';

part 'BaseResponse.g.dart';

@JsonSerializable()
class BaseResponse {
  dynamic? status;
  String? msg;

  BaseResponse(
      {this.status,
        this.msg});

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}
