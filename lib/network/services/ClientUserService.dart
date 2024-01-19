
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../model/ClientUsers/ClientUserData.dart';
import '../interface/InterfaceClientUsers.dart';
import 'ApiService.dart';

class ClientUserService implements InterfaceClientUsers{

  /** List Client User **/
  @override
  Future<List<ClientUserData>> getClientUserData(String task,String user_id) async{
    try{
      var map = {
        'task': task,
        'user_id':user_id
      };

      var response =
      await NetworkClient().dio.get(base_url,queryParameters: map);
      log("this is response of getClientUserData  ${response}");


      if (response.statusCode == 200) {
        // var data = ClientUserData.fromJson(json.decode(response.data));

        List<ClientUserData> data = List<ClientUserData>.from(json
            .decode(response.data)
            .map((model) => ClientUserData.fromJson(model)));
        log(
          "response done for getClientUserData ${data.toString()}",
        );
        return data;
      } else {
        log("response other than 200 for getClientUserData");
        throw "response other than 200 for getClientUserData";

        // var errorData = BaseResponse(task: "", values: []);
        // errorData.errorCode ="400";
        // errorData.errorMessage="Error occurred while fetching data";
        // return errorData;
        // log("Error");
      }

    }on DioException catch (error) {
      log("EXCEPTION IN getClientUserData ${error.response}");
      throw "exeption caught IN getClientUserData";

    }
  }

/** Add Client User **/

/** Edit Client User **/

/** Update Client User **/

/** Delete Client User **/
}

