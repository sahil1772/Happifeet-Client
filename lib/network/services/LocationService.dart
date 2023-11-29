import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:happifeet_client_app/model/Location/LocationData.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/network/interface/InterfaceLocation.dart';
import 'package:happifeet_client_app/network/services/ApiService.dart';

class LocationService implements InterfaceLocation {
  @override
  Future<BaseResponse> submitLocationData(LocationData data) async {
    //Converting LocationData Object to Map<String,dynamic>
    Map paramMap = data.toJson();
    //Adding task to Map
    paramMap.addAll({"task": "addLocation"});

    //Calling Post API
    var response = await NetworkClient()
        .dio
        .post(base_url, data: FormData.fromMap(data.toJson()));

    //Checking for successful response
    if (response.statusCode == 200) {
      //Return Success Response Object as BaseResponse Class Object
      var data = BaseResponse.fromJson(json.decode(response.data));
      return data;
    } else {
      //Return Failure Response Object as BaseResponse Class Object
      return BaseResponse(status: response.statusCode, msg: response.statusMessage);
    }
  }
}
