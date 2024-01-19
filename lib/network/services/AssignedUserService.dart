




import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:happifeet_client_app/model/AssignedUsers/AssignedUserData.dart';
import 'package:happifeet_client_app/model/AssignedUsers/UpdateAssignedUserData.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/network/interface/InterfaceAssignedUsers.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';

import '../../model/AssignedUsers/SubmitAssignedUserData.dart';
import 'ApiService.dart';

class AssignedUserService implements InterfaceAssignedUsers {

  /** list assigned user **/
  @override
  Future<List<AssignedUserData>> getUserData(String task,String user_id) async{
    try{
      var map = {
        'task': task,
        'user_id':user_id
      };


      var response =
          await NetworkClient().dio.get(base_url,queryParameters: map);
      log("this is response of getUserData  ${response}");


      if (response.statusCode == 200) {
        List<AssignedUserData> data = List<AssignedUserData>.from(json
            .decode(response.data)
            .map((model) => AssignedUserData.fromJson(model)));
        log(
          "response done for getUserData ${data.toString()}",
        );
        return data;
      } else {
        log("response other than 200 for getUserData");
        throw "response other than 200 for getUserData";

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


  /** add assigned user **/
  @override
  Future<BaseResponse> submitUserData(SubmitAssignedUserData data) async{
    try{


      var map = data.toJson();

      map.addAll({"task":"add_assigned_users",});
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
      log("EXCEPTION IN submitUserData ${error.response}");
      throw "exeption caught IN submitUserData";

    }
  }



  /** edit user details **/

  @override
  Future<AssignedUserData> editUserData(String task, String id) async{
    try{

      var map = {
        "task":task,
        "id":id
      };

      var response = await NetworkClient()
          .dio
          .post(base_url,queryParameters: map);


      if (response.statusCode == 200) {
        var data = AssignedUserData.fromJson(json.decode(response.data));
        // List<AssignedUserData> data = List<AssignedUserData>.from(json
        //     .decode(response.data)
        //     .map((model) => AssignedUserData.fromJson(model)));
        log(
          "response done for editUserData ${data.toString()}",
        );
        return data;
      } else {
        log("response other than 200 for editUserData");
        throw "response other than 200 for editUserData";

      }

    }on DioException catch (error) {
      log("EXCEPTION IN submitUserData ${error.response}");
      throw "exeption caught IN submitUserData";

    }

  }


  /** update user details **/
  @override
  Future<BaseResponse> updateUserData(UpdateAssignedUserData data) async{
    //Converting LocationData Object to Map<String,dynamic>
    var updDataMap = data.toJson();
    //Adding task to Map
    updDataMap.addAll({"task": "update_assigned_user"});
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




  /** Delete user details **/
  @override
  Future<BaseResponse> deleteUserData(String task, String id) async{
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
      log("EXCEPTION IN deleteLocationData ${error.response}");
      throw "exeption caught IN deleteLocationData";

    }
  }







  
}