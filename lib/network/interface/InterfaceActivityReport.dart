import 'package:happifeet_client_app/model/ActivityReport/ActivityReportData.dart';

import '../../model/FilterMap.dart';

abstract class InterfaceActivityReport {

  Future<List<ActivityReportData>>? getActivityReportListing(FilterMap? params);

}