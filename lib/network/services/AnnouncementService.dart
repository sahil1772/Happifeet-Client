import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:happifeet_client_app/model/Announcement/AnnouncementData.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/network/interface/InterfaceAnnouncement.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import 'ApiService.dart';

class AnnouncementService implements InterfaceAnnouncement {
  /** list announcement **/

  @override
  Future<List<AnnouncementData>> getAnnouncementList(
      String task, String client_id) async {
    try {
      var map = {'task': task, 'client_id': client_id};

      var response =
          await NetworkClient().dio.get(base_url, queryParameters: map);
      log("this is response of getAnnouncementList  ${response}");

      if (response.statusCode == 200) {
        List<AnnouncementData> data = List<AnnouncementData>.from(json
            .decode(response.data)
            .map((model) => AnnouncementData.fromJson(model)));
        log(
          "response done for getAnnouncementList ${data.toString()}",
        );
        return data;
      } else {
        log("response other than 200 for getAnnouncementList");
        throw "response other than 200 for getAnnouncementList";

        // var errorData = BaseResponse(task: "", values: []);
        // errorData.errorCode ="400";
        // errorData.errorMessage="Error occurred while fetching data";
        // return errorData;
        // log("Error");
      }
    } on DioException catch (error) {
      log("EXCEPTION IN getLocationListService ${error.response}");
      throw "exeption caught IN getLocationListService";
    }
  }

  /** Search announcement **/

  /** Submit announcement details **/
  @override
  Future<BaseResponse> submitAnnouncementDetails(AnnouncementData data,XFile? announcmentImage) async {
    try {
      var map = data.toJson();

      map.addAll({
        "task": "add_announcement",
        "client_id": await SharedPref.instance.getUserId()
      });

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
        return BaseResponse(
            status: response.statusCode, msg: response.statusMessage);
      }
    } on DioException catch (error) {
      log("EXCEPTION IN submitAnnouncementDetails ${error.response}");
      throw "exeption caught IN submitAnnouncementDetails";
    }
  }

  @override
  Future<BaseResponse> submitOtherLanguageAnnouncementDetails(AnnouncementData data) {
    // TODO: implement submitOtherLanguageAnnouncementDetails
    throw UnimplementedError();
  }
}
