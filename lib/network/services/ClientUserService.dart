
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../model/BaseResponse.dart';
import '../../model/ClientUsers/AddClientUser.dart';
import '../../model/ClientUsers/ClientUserData.dart';
import '../../model/ClientUsers/EditClientUser.dart';
import '../../model/ClientUsers/UpdateClientUser.dart';
import '../../storage/shared_preferences.dart';
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

  @override
  Future<BaseResponse> submitClientUserData(AddClientUser data) async{
    try{

      var map = data.toJson();

      map.addAll({"task":"add_client_users",});
      map.addAll({"user_id":await SharedPref.instance.getUserId()});

      var response = await NetworkClient()
          .dio
          .post(base_url,data: FormData.fromMap(map));

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
      log("EXCEPTION IN submitClientData ${error.response}");
      throw "exeption caught IN submitClientData";

    }
  }


  /** edit client user **/

  @override
  Future<EditClientUser> editClientUserData(String task, String id) async{
    try{

      var map = {
        "task":task,
        "id":id
      };

      var response = await NetworkClient()
          .dio
          .post(base_url,queryParameters: map);


      if (response.statusCode == 200) {
        var data = EditClientUser.fromJson(json.decode(response.data));
        // List<AssignedUserData> data = List<AssignedUserData>.from(json
        //     .decode(response.data)
        //     .map((model) => AssignedUserData.fromJson(model)));
        log(
          "response done for editClientUserData ${data.toString()}",
        );
        return data;
      } else {
        log("response other than 200 for editClientUserData");
        throw "response other than 200 for editClientUserData";

      }

    }on DioException catch (error) {
      log("EXCEPTION IN editClientUserData ${error.response}");
      throw "exeption caught IN editClientUserData";

    }

  }



  /** update client user details **/
  @override
  Future<BaseResponse> updateClientUserData(UpdateClientUser data) async{
    //Converting LocationData Object to Map<String,dynamic>
    var updDataMap = data.toJson();
    //Adding task to Map
    updDataMap.addAll({"task": "update_client_users"});
    updDataMap.addAll({"user_id": await SharedPref.instance.getUserId()});


    //Calling Post API
    var response = await NetworkClient()
        .dio
        .post(base_url ,data: FormData.fromMap(updDataMap));

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







  /** Delete client user details **/
  @override
  Future<BaseResponse> deleteClientUserData(String task, String id) async{
    try{

      var map = {
        "task":task,
        "id":id

      };

      map.addAll({"user_id":await SharedPref.instance.getUserId()});

      var response = await NetworkClient()
          .dio
          .get(base_url, queryParameters:map);

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
      log("EXCEPTION IN deleteClientUserData ${error.response}");
      throw "exeption caught IN deleteClientUserData";

    }
  }




}

