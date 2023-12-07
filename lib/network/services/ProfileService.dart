

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:happifeet_client_app/network/interface/InterfaceProfile.dart';

import '../../model/BaseResponse.dart';
import 'ApiService.dart';

class ProfileService implements InterfaceProfile{
  @override
  Future<BaseResponse> sendPasswordDetails(String task, String user_id,String oldPassword,String newPassword) async{

    try{

      var map =  {
      "task" : task,
      "user_id" : user_id,
        "oldPassword" :oldPassword,
        "newPassword" : newPassword

    };

      var response =
          await NetworkClient().dio.post(base_url,data: FormData.fromMap(map));
      log("this is response of send pass details ${response}");

      log("this is response sending pass details ${response.statusCode}");

      if (response.statusCode == 200) {
        // var data = SuccessResponse.fromJson(json.decode(response.data));
        var data = List<BaseResponse>.from(json
            .decode(response.data)
            .map((model) => BaseResponse.fromJson(model)));

        log("forgot password data send successfully");
        return data.first;
      }
      else{
        log("forgot password data sending failed");
        return BaseResponse(status: "400",msg: "Response is Faliure");
      }

    }on DioException catch (error) {
      log("EXCEPTION IN sendPasswordDetails ${error.response}");
      throw "exeption caught IN sendPasswordDetails";

    }
  }

}