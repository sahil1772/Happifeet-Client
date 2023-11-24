import '../../model/SMTP/SmtpDetails.dart';

abstract class InterfaceSmtp{
  Future<List<SmtpDetails>> getSmtpDetails(String task, String user_id);
}