

import 'package:happifeet_client_app/model/FeedbackStatus/FeedbackStatusData.dart';

import '../../model/FeedbackStatus/FeedbackStatusDetails.dart';

abstract class InterfaceFeedbackStatus{
  Future<List<FeedbackStatusDetails>> getFeedbackStatusDetails(String task, String report_id);
  Future<List<FeedbackStatusData>> getFeedbackStatusListing(String task,String user_id);
}