import 'package:happifeet_client_app/model/BaseResponse.dart';

import '../../model/SMTP/SmtpDataModel.dart';
import '../../model/SMTP/SmtpDetails.dart';

abstract class InterfaceSmtp{
  Future<List<SmtpDetails>> getSmtpDetails(String task, String user_id);
  Future<BaseResponse> sendSmtpDetails(SmtpDataModel data);
}