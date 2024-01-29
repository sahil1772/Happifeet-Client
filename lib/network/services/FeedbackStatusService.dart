import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:happifeet_client_app/model/FeedbackStatus/FeedbackStatusData.dart';
import 'package:happifeet_client_app/network/interface/InterfaceFeedbackStatus.dart';

import '../../model/FeedbackStatus/FeedbackStatusDetails.dart';
import 'ApiService.dart';

class FeedbackStatusService implements InterfaceFeedbackStatus{


  /** GET FEEDBACK STATUS DETAILS **/
  Future<List<FeedbackStatusDetails>> getFeedbackStatusDetails(String task, String report_id) async {
    try {
      var map = {
        'task': task,
        'report_id': report_id,
      };

      var response =
      await NetworkClient().dio.post(base_url, queryParameters: map);
      log("this is response of getFeedbackStatusDetails $response");

      if (response.statusCode == 200) {

        List<FeedbackStatusDetails> data = List<FeedbackStatusDetails>.from(json
            .decode(response.data)
            .map((model) => FeedbackStatusDetails.fromJson(model)));

        log("getFeedbackStatusDetails data received successfully");
        return data;
      } else {
        log("getFeedbackStatusDetails failed ${response.statusMessage}");
        throw "response other than 200 for getFeedbackStatusDetails";
      }
    } on DioException catch (error) {
      log("EXCEPTION IN getFeedbackStatusDetails ${error.response}");
      throw "exeption caught IN getFeedbackStatusDetails";
    }
  }






  /** GET FEEDBACK STATUS LISTING **/
  @override
  Future<List<FeedbackStatusData>> getFeedbackStatusListing(String task, String user_id) async {
    try {
      var map = {
        'task': task,
        'user_id': user_id,
      };

      var response =
          await NetworkClient().dio.post(base_url, queryParameters: map);
      log("this is response of getFeedbackStatusListing $response");

      if (response.statusCode == 200) {

        List<FeedbackStatusData> data = List<FeedbackStatusData>.from(json
            .decode(response.data)
            .map((model) => FeedbackStatusData.fromJson(model)));

        log("getFeedbackStatusListing data received successfully");
        return data;
      } else {
        log("getFeedbackStatusListing failed ${response.statusMessage}");
        throw "response other than 200 for getFeedbackStatusListing";
      }
    } on DioException catch (error) {
      log("EXCEPTION IN getFeedbackStatusListing ${error.response}");
      throw "exeption caught IN getFeedbackStatusListing";
    }
  }

}