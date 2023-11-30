
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:happifeet_client_app/model/Location/LocationDataModel.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/network/interface/InterfaceLocation.dart';
import 'package:happifeet_client_app/network/services/ApiService.dart';

import '../../model/Location/LocationData.dart';

class LocationService implements InterfaceLocation {
  @override
  Future<BaseResponse> submitLocationData(LocationDataModel data) async {
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

  @override
  Future<List<LocationData>> getLocationListService(String task) async{
    try{
      var map = {
        'task': task,
      };


      var response =
      await NetworkClient().dio.get(base_url,queryParameters: map);
      log("this is response of LocationData  ${response}");


      if (response.statusCode == 200) {
        List<LocationData> data = List<LocationData>.from(json
            .decode(response.data)
            .map((model) => LocationData.fromJson(model)));
        log(
          "response done ${data.toString()}",
        );
        return data;
      } else {
        log("response other than 200 for LocationData");
        throw "response other than 200 for LocationData";

        // var errorData = BaseResponse(task: "", values: []);
        // errorData.errorCode ="400";
        // errorData.errorMessage="Error occurred while fetching data";
        // return errorData;
        // log("Error");
      }




    }on DioException catch (error) {
      log("EXCEPTION IN getLocationListService ${error.response}");
      throw "exeption caught IN getLocationListService";

    }
  }
}

