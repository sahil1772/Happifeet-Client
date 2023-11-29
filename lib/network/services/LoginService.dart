import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../model/BaseResponse.dart';
import '../interface/interface_login.dart';
import 'ApiService.dart';

class LoginService implements InterfaceLogin{


  ///send forgot password details
  @override
  Future<BaseResponse> sendForgotPasswordDetails(String task, String username, String new_password) async{
  try{


    var map = {
      'task' : task,
      'username': username,
      'new_password' : new_password
    };

    var response =
        await NetworkClient().dio.post(base_url,data: FormData.fromMap(map));
    log("this is response of forgot password $response");

    log("this is response sending forgot password data ${response.statusCode}");

    if (response.statusCode == 200) {
      // var data = BaseResponse.fromJson(json.decode(response.data));
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
    log("EXCEPTION IN sendForgotPasswordData ${error.response}");
    throw "exeption caught IN sendForgotPasswordData";

  }
  }


  /// send login details
  @override
  Future<BaseResponse> sendLoginDetails(String task, String username, String password) async{
   try{

     var map = {
       'task' : task,
       'username': username,
       'password' : password
     };

     var response =
         await NetworkClient().dio.post(base_url,data: FormData.fromMap(map));
     log("this is response of login data $response");


     log("this is response sending login data ${response.statusCode}");

     if (response.statusCode == 200) {
       // var data = BaseResponse.fromJson(json.decode(response.data));
       var data = List<BaseResponse>.from(json
           .decode(response.data)
           .map((model) => BaseResponse.fromJson(model)));

       log("login data send successfully");
       return data.first;
     }
     else{
       log("login data sending failed");
       return BaseResponse(status: "400",msg: "Response is Faliure");
     }

   }on DioException catch (error) {
     log("EXCEPTION IN getLoginDetails ${error.response}");
     throw "exeption caught IN getLoginDetails";

   }
  }




  
}