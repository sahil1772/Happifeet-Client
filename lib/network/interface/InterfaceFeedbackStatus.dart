import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/model/FeedbackStatus/FeedbackStatusData.dart';
import 'package:happifeet_client_app/model/FilterMap.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/FeedbackStatus/FeedbackStatusDetails.dart';

abstract class InterfaceFeedbackStatus {
  Future<List<FeedbackStatusDetails>> getFeedbackStatusDetails(
      String task, String report_id);

  Future<List<FeedbackStatusData>> getFeedbackStatusListing(
      FilterMap? params);

  Future<BaseResponse> downloadReport({FilterMap? filterParams});

  Future<BaseResponse> submitComment(Map<String, dynamic> params,List<XFile>? files);
}
