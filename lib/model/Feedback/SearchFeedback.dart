


import 'package:json_annotation/json_annotation.dart';

part 'SearchFeedback.g.dart';

@JsonSerializable()

class SearchFeedback{
  String? type;
  String? srchFromDate;
  String? srchToDate;
  String? status;

  SearchFeedback({
    this.type,
    this.srchFromDate,
    this.srchToDate,
    this.status

});


  factory SearchFeedback.fromJson(Map<String, dynamic> json) =>
      _$SearchFeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$SearchFeedbackToJson(this);


}