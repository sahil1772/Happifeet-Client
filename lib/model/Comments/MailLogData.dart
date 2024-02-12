import 'package:json_annotation/json_annotation.dart';

part 'MailLogData.g.dart';

@JsonSerializable()
class MailLogData {
String? subject;
String? comment;
String? add_date;


MailLogData(
      {
this.subject,
        this.comment,
        this.add_date

      });

  factory MailLogData.fromJson(Map<String, dynamic> json) =>
      _$MailLogDataFromJson(json);

  Map<String, dynamic> toJson() => _$MailLogDataToJson(this);
}
