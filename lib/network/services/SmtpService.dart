import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/model/SMTP/SmtpDetails.dart';

import '../../model/SMTP/SmtpDataModel.dart';
import '../interface/InterfaceSmtp.dart';
import 'ApiService.dart';

class SmtpService implements InterfaceSmtp {
  /** SEND SMTP DATA **/


  @override
  Future<BaseResponse> sendSmtpDetails(SmtpDataModel data) async{
   try{
     var map = data.toJson();

     map.addAll({"task": "updateSMTP"});

     var response = await NetworkClient()
         .dio
         .post(base_url, data: FormData.fromMap(map));


     //Checking for successful response
     if (response.statusCode == 200) {
       //Return Success Response Object as BaseResponse Class Object
       var data = BaseResponse.fromJson(json.decode(response.data));
       return data;
     } else {
       //Return Failure Response Object as BaseResponse Class Object
       return BaseResponse(status: response.statusCode, msg: response.statusMessage);
     }

   }on DioException catch (error) {
     log("EXCEPTION IN sendSmtpDetails ${error.response}");
     throw "exeption caught IN sendSmtpDetails";
   }

  }







  /** get SMTP data **/

  @override
  Future<SmtpDetails> getSmtpDetails(String task, String client_id) async {
    try {
      var map = {
        'task': task,
        'client_id': client_id,
      };

      var response =
          await NetworkClient().dio.post(base_url, queryParameters: map);
      log("this is response of forgot password $response");

      if (response.statusCode == 200) {
        var data = SmtpDetails.fromJson(json.decode(response.data));
        // var data = List<SmtpDetails>.from(json
        //     .decode(response.data)
        //     .map((model) => SmtpDetails.fromJson(model)));

        log("forgot password data send successfully");
        return data;
      } else {
        log("getSmtpDetails failed ${response.statusMessage}");
        throw "response other than 200 for get SMTP data";
      }
    } on DioException catch (error) {
      log("EXCEPTION IN getSmtpDetails ${error.response}");
      throw "exeption caught IN getSmtpDetails";
    }
  }


}
