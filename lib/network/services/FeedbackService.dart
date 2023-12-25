



import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:happifeet_client_app/model/Announcement/AnnouncementData.dart';

import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/model/Feedback/FeedbackData.dart';
import 'package:happifeet_client_app/model/Feedback/SearchFeedback.dart';
import 'package:happifeet_client_app/network/interface/InrerfaceFeedback.dart';

import '../interface/InterfaceAnnouncement.dart';
import 'ApiService.dart';

class FeedbackService implements InterfaceFeedback {


  /** view feedback report **/


  /** delete feedback **/

  Future<BaseResponse> deleteFeedback (String task,String report_id) async{
    try{


      var map = {
        'task' :task,
        'report_id': report_id
      };


      var response =
      await NetworkClient().dio.get(base_url,queryParameters: map);
      log("this is response of deleteFeedback  ${response}");



        if (response.statusCode == 200) {
          //Return Success Response Object as BaseResponse Class Object
          var data = BaseResponse.fromJson(json.decode(response.data));
          return data;
        } else {
          //Return Failure Response Object as BaseResponse Class Object
          return BaseResponse(status: response.statusCode, msg: response.statusMessage);
        }



    }on DioException catch (error) {
      log("EXCEPTION IN deleteFeedback ${error.response}");
      throw "exeption caught IN deleteFeedback";

    }
  }



  /** search feedback **/


  @override
  Future<List<SearchFeedback>> searchFeedback(SearchFeedback data) async{
    try{
      var map = data.toJson();

      map.addAll({"task":"feedback_status_search"});


      var response =
          await NetworkClient().dio.get(base_url,queryParameters: map);
      log("this is response of searchFeedback  ${response}");


      if (response.statusCode == 200) {
        List<SearchFeedback> data = List<SearchFeedback>.from(json
            .decode(response.data)
            .map((model) => SearchFeedback.fromJson(model)));
        log(
          "response done for searchFeedback ${data.toString()}",
        );
        return data;
      } else {
        log("response other than 200 for searchFeedback");
        throw "response other than 200 for searchFeedback";

        // var errorData = BaseResponse(task: "", values: []);
        // errorData.errorCode ="400";
        // errorData.errorMessage="Error occurred while fetching data";
        // return errorData;
        // log("Error");
      }

    }on DioException catch (error) {
      log("EXCEPTION IN searchFeedback ${error.response}");
      throw "exeption caught IN searchFeedback";

    }
  }


  /** get feedback list **/
  @override
  Future<List<FeedbackData>> getFeedbackList(FeedbackData data) async{
    try{
      var map = data.toJson();

      map.addAll({"task":"feedback_list"});


      var response =
          await NetworkClient().dio.get(base_url,queryParameters: map);
      log("this is response of getFeedbackList  ${response}");


      if (response.statusCode == 200) {
        List<FeedbackData> data = List<FeedbackData>.from(json
            .decode(response.data)
            .map((model) => FeedbackData.fromJson(model)));
        log(
          "response done for getFeedbackList ${data.toString()}",
        );
        return data;
      } else {
        log("response other than 200 for getFeedbackList");
        throw "response other than 200 for getFeedbackList";

        // var errorData = BaseResponse(task: "", values: []);
        // errorData.errorCode ="400";
        // errorData.errorMessage="Error occurred while fetching data";
        // return errorData;
        // log("Error");
      }

    }on DioException catch (error) {
      log("EXCEPTION IN getFeedbackList ${error.response}");
      throw "exeption caught IN getFeedbackList";

    }
  }




}