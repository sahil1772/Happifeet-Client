import 'package:json_annotation/json_annotation.dart';

part 'SuccessResponse.g.dart';

@JsonSerializable()
class SuccessResponse {
  dynamic? status;
  String? msg;

  SuccessResponse(
      {this.status,
        this.msg});

  factory SuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$SuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SuccessResponseToJson(this);
}
