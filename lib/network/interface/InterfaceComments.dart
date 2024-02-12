import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/model/Comments/CommentData.dart';
import 'package:happifeet_client_app/model/FilterMap.dart';

import '../../model/Comments/MailLogData.dart';

abstract class InterfaceComments {
  Future<List<CommentData>>? getComments(FilterMap? params);
  Future<BaseResponse>? sendEmailData(String email, String subject, String comment);
  Future<List<MailLogData>> getMailUserLog(String report_id);
}
