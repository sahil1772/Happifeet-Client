import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:happifeet_client_app/model/ApiResponse.dart';
import 'package:happifeet_client_app/model/DashboardModels/DashboardResponse.dart';
import 'package:happifeet_client_app/network/interface/InterfaceDashboard.dart';
import 'package:happifeet_client_app/network/services/ApiService.dart';

class DashboardService implements InterfaceDashboard {
  @override
  Future<Response?> getParkAnalytics(String? parkId, String? type) async {
    try {
      var map = {
        'task': "dashboard",
        'client': 302,
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
}
