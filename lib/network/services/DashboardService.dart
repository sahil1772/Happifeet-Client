import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:happifeet_client_app/model/ApiResponse.dart';
import 'package:happifeet_client_app/model/DashboardModels/DashboardResponse.dart';
import 'package:happifeet_client_app/network/interface/InterfaceDashboard.dart';
import 'package:happifeet_client_app/network/services/ApiService.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';

class DashboardService implements InterfaceDashboard {
  @override
  Future<Response?> getParkAnalytics(String? parkId, String? type) async {
    try {
      var map = {
        'task': "dashboard",
        'client': await SharedPref.instance.getUserId(),
        'park': parkId,
        'report_type': type,
      };

      var response =
          await NetworkClient().dio.post(base_url, data: FormData.fromMap(map));

      if (response.statusCode == 200) {
        //Return Success Response Object as BaseResponse Class Object
        return response;
      } else {
        //Return Failure Response Object as BaseResponse Class Object
        return null;
      }
    } on DioException catch (error) {
      throw "Error Occurred for getParkAnalytics ${error}";
    }
  }

  @override
  Future<Response?> getParks(String? client_user_id) async {
    try {
      var map = {
        'task': "locationlist",
        'client': client_user_id
      };

      var clientUser = await SharedPref.instance.getClientId();

      var response =
          await NetworkClient().dio.post(base_url, data: FormData.fromMap(map));

      if (response.statusCode == 200) {
        //Return Success Response Object as BaseResponse Class Object
        return response;
      } else {
        //Return Failure Response Object as BaseResponse Class Object
        return null;
      }
    } on DioException catch (error) {
      throw "Error Occurred for getParks ${error}";
    }
  }
}
