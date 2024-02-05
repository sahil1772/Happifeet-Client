

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:happifeet_client_app/model/ActivityReport/ActivityReportData.dart';
import 'package:happifeet_client_app/network/interface/InterfaceActivityReport.dart';

import 'ApiService.dart';

class ActivityReportService implements InterfaceActivityReport{
  @override
  Future<List<ActivityReportData>>? getActivityReportListing(String? task, String user_id) async{
    try {
      var map = {'task': task, 'user_id': user_id};

      var response =
          await NetworkClient().dio.get(base_url, queryParameters: map);
      log("this is response of getActivityReportListing  ${response}");

      if (response.statusCode == 200) {
        List<ActivityReportData> data = List<ActivityReportData>.from(json
            .decode(response.data)
            .map((model) => ActivityReportData.fromJson(model)));
        log(
          "response done for getActivityReportListing ${data.toString()}",
        );
        return data;
      } else {
        log("response other than 200 for getActivityReportListing");
        throw "response other than 200 for getActivityReportListing";

        // var errorData = BaseResponse(task: "", values: []);
        // errorData.errorCode ="400";
        // errorData.errorMessage="Error occurred while fetching data";
        // return errorData;
        // log("Error");
      }
    } on DioException catch (error) {
      log("EXCEPTION IN getLocationListService ${error.response}");
      throw "exeption caught IN getLocationListService";
    }
  }
  
}