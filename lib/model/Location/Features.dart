import 'package:json_annotation/json_annotation.dart';

part 'Features.g.dart';

@JsonSerializable()
class Features {
  String? id;
  String? name;
  String? icon;

  Features({this.id, this.name, this.icon});

  factory Features.fromJson(Map<String, dynamic> json) =>
      _$FeaturesFromJson(json);

  Map<String, dynamic> toJson() => _$FeaturesToJson(this);
}
