import 'package:happifeet_client_app/model/ActivityReport/ActivityReportData.dart';

abstract class InterfaceActivityReport {

  Future<List<ActivityReportData>>? getActivityReportListing(String? task,String user_id);

}