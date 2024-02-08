

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:happifeet_client_app/model/ActivityReport/ActivityReportData.dart';
import 'package:happifeet_client_app/network/interface/InterfaceActivityReport.dart';

import '../../model/FilterMap.dart';
import '../../storage/shared_preferences.dart';
import 'ApiService.dart';

// "activity_report_list", await SharedPref.instance.getUserId()

class ActivityReportService implements InterfaceActivityReport{
  @override
  Future<List<ActivityReportData>>? getActivityReportListing(FilterMap? params) async{
    try {
      // var map = {'task': task, 'user_id': user_id};
      var map = params!.toJson();
      map.removeWhere((key, value) => value == null || value == "");
      map.addAll({
        'task': "activity_report_list",
        'user_id': await SharedPref.instance.getUserId(),
      });

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