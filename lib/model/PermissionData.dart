
import 'package:json_annotation/json_annotation.dart';

part 'PermissionData.g.dart';

@JsonSerializable()


class PermissionData {
  String? name;
  String? img;

  PermissionData({
    this.name,
    this.img

});
  factory PermissionData.fromJson(Map<String, dynamic> json) =>
      _$PermissionDataFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionDataToJson(this);


}