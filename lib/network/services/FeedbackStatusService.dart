import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/model/FeedbackStatus/FeedbackStatusData.dart';
import 'package:happifeet_client_app/model/FilterMap.dart';
import 'package:happifeet_client_app/network/interface/InterfaceFeedbackStatus.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/FeedbackStatus/FeedbackStatusDetails.dart';
import 'ApiService.dart';

class FeedbackStatusService implements InterfaceFeedbackStatus {
  /** GET FEEDBACK STATUS DETAILS **/
  Future<List<FeedbackStatusDetails>> getFeedbackStatusDetails(
      String task, String report_id) async {
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
  Future<List<FeedbackStatusData>> getFeedbackStatusListing(
      FilterMap? params) async {
    try {
      var map = params!.toJson();
      map.removeWhere((key, value) => value == null || value == "");
      map.addAll({
        'task': "feedback_status_report_list",
        'user_id': await SharedPref.instance.getUserId(),
      });

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

  @override
  Future<BaseResponse> submitComment(
      Map<String, dynamic> params, List<XFile>? files) async {
    try {
      params.removeWhere((key, value) => value == null || value == "");
      params.addAll({
        'task': "comment_submit",
        'assignedby': await SharedPref.instance.getUserId(),
        'user_id': await SharedPref.instance.getUserId(),
      });
      FormData form = FormData.fromMap(params);
      for (var file in files!) {
        form.files.add(
          MapEntry("fileToUpload", await MultipartFile.fromFile(file.path)),
        );
      }

      var response = await NetworkClient()
          .dio
          .post(base_url, queryParameters: params, data: form);

      if (response.statusCode == 200) {
        BaseResponse baseResponse =
            BaseResponse.fromJson(json.decode(response.data));
        return baseResponse;
      } else {
        log("getFeedbackStatusListing failed ${response.statusMessage}");
        throw "response other than 200 for getFeedbackStatusListing";
      }
    } on DioException catch (error) {
      log("EXCEPTION IN getFeedbackStatusListing ${error.response}");
      throw "exeption caught IN getFeedbackStatusListing";
    }
  }

  @override
  Future<BaseResponse> downloadReport({FilterMap? filterParams}) async {
    try {
      Map<String, dynamic> params = filterParams!.toJson();
      params.removeWhere((key, value) => value == null || value == "");
      params.addAll({
        'task': "feedback_status_report_export",
        'user_id': await SharedPref.instance.getUserId(),
      });

      var response = await NetworkClient().dio.post(base_url,
          queryParameters: params, data: FormData.fromMap(params));

      if (response.statusCode == 200) {
        BaseResponse baseResponse =
        BaseResponse.fromJson(response.data);
        return baseResponse;
      } else {
        log("downloadReport failed ${response.statusMessage}");
        throw "response other than 200 for downloadReport";
      }
    } on DioException catch (error) {
      log("EXCEPTION IN downloadReport ${error.response}");
      throw "exeption caught IN downloadReport";
    }
  }


}
