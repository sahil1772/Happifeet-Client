

import 'package:happifeet_client_app/model/Feedback/SearchFeedback.dart';

import '../../model/Feedback/FeedbackData.dart';

abstract class InterfaceFeedback{

  Future<List<SearchFeedback>> searchFeedback(SearchFeedback data);

  Future<List<FeedbackData>> getFeedbackList(FeedbackData data);
}