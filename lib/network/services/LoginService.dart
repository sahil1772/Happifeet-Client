import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../model/BaseResponse.dart';
import '../../model/Login/LoginData.dart';
import '../interface/InterfaceLogin.dart';
import 'ApiService.dart';

class LoginService implements InterfaceLogin{

  ///update new password
   @override
    Future<BaseResponse> updateNewPassword(String task, String email, String newPassword) async{
     try{
       var map = {
         'task' : task,
         'email': email,
         'new_password':newPassword
       };

       var response =
           await NetworkClient().dio.post(base_url,data: FormData.fromMap(map));
       log("this is response of updateNewPassword $response");

       log("this is response updateNewPassword ${response.statusCode}");

       if (response.statusCode == 200) {
         // var data = BaseResponse.fromJson(json.decode(response.data));

         // var data = List<BaseResponse>.from(json
         //     .decode(response.data)
         //     .map((model) => BaseResponse.fromJson(model)));

         var data = BaseResponse.fromJson(json.decode(response.data));

         log("response for updateNewPassword ${data.toJson()}");
         return data;
       }
       else{
         log("updateNewPassword failed");
         return BaseResponse(status: "400",msg: "Response is Faliure");
       }



     }on DioException catch (error) {
       log("EXCEPTION IN updateNewPassword ${error.response}");
       throw "exeption caught IN updateNewPassword";

     }
    }



  ///verify otp to reset password
   @override
    Future<BaseResponse> sendOtpToResetPassword(String task, String email, String otp) async{
     try{

       var map = {
         'task' : task,
         'email': email,
         'otp':otp

       };

       var response =
       await NetworkClient().dio.post(base_url,data: FormData.fromMap(map));
       log("this is response of sendOtpToResetPassword $response");

       log("this is response sendOtpToResetPassword ${response.statusCode}");

       if (response.statusCode == 200) {
         // var data = BaseResponse.fromJson(json.decode(response.data));

         // var data = List<BaseResponse>.from(json
         //     .decode(response.data)
         //     .map((model) => BaseResponse.fromJson(model)));

         var data = BaseResponse.fromJson(json.decode(response.data));

        log("response for sendOtpToResetPassword ${data.toJson()}");
         return data;
       }
       else{
         log("sendOtpToResetPassword failed");
         return BaseResponse(status: "400",msg: "Response is Faliure");
       }


     }on DioException catch (error) {
       log("EXCEPTION IN sendOtpToResetPassword ${error.response}");
       throw "exeption caught IN sendOtpToResetPassword";

     }
    }



  ///send email if forgot password
  @override
  Future<BaseResponse> sendEmailIfForgotPassword(String task, String email) async{
  try{


    var map = {
      'task' : task,
      'email': email,

    };

    var response =
        await NetworkClient().dio.post(base_url,data: FormData.fromMap(map));
    log("this is response of sendEmailIfForgotPassword $response");

    log("this is response ssendEmailIfForgotPassword ${response.statusCode}");

    if (response.statusCode == 200) {
      // var data = BaseResponse.fromJson(json.decode(response.data));

      // var data = List<BaseResponse>.from(json
      //     .decode(response.data)
      //     .map((model) => BaseResponse.fromJson(model)));

      var data = BaseResponse.fromJson(json.decode(response.data));

      log("forgot password data send successfully");
      return data;
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
  Future<LoginData> sendLoginDetails(String task, String username, String password) async{
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
       var data = LoginData.fromJson(json.decode(response.data));

       // var data = List<BaseResponse>.from(json
       //     .decode(response.data)
       //     .map((model) => BaseResponse.fromJson(model)));

       log("login data send successfully");
       return data;
     }
     else{
       log("login data sending failed");
       return LoginData(status: "400",msg: "Response is Faliure");
     }

   }on DioException catch (error) {
     log("EXCEPTION IN getLoginDetails ${error.response}");
     throw "exeption caught IN getLoginDetails";

   }
  }






  
}