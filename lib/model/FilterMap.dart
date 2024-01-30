import 'package:json_annotation/json_annotation.dart';

part 'FilterMap.g.dart';

@JsonSerializable()
class FilterMap{
  String? type;
  String? main_park_id;
  String? status;
  String? frm_keyword;
  String? popupDatepickerFromDateSearch;
  String? popupDatepickerToDateSearch;
  String? functionType;


  FilterMap(
      {this.type,
      this.main_park_id,
      this.status,
      this.frm_keyword,
      this.popupDatepickerFromDateSearch,
      this.popupDatepickerToDateSearch,
      this.functionType});

  factory FilterMap.fromJson(Map<String, dynamic> json) =>
      _$FilterMapFromJson(json);

  Map<String, dynamic> toJson() => _$FilterMapToJson(this);
}