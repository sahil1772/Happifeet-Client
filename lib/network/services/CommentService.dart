import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/model/Comments/CommentData.dart';
import 'package:happifeet_client_app/model/FilterMap.dart';
import 'package:happifeet_client_app/network/interface/InterfaceComments.dart';
import 'package:happifeet_client_app/network/services/ApiService.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';

class CommentService implements InterfaceComments {
  /** get Comments listing **/
  @override
  Future<List<CommentData>>? getComments(FilterMap? params) async {
    try {
      var map = params!.toJson();
      map.removeWhere((key, value) => value == null || value == "");
      map.addAll({
        'task': "feedback_report_list",
        'user_id': await SharedPref.instance.getUserId()
      });

      var response =
          await NetworkClient().dio.get(base_url, queryParameters: map);

      if (response.statusCode == 200) {
        List<CommentData> data = List<CommentData>.from(json
            .decode(response.data)
            .map((model) => CommentData.fromJson(model)));

        return data;
      } else {
        throw "${response.statusCode} received from Server.\n\n Response => ${response.statusMessage}";
      }
    } on DioException catch (error) {
      log("EXCEPTION IN getClientUserData ${error.response}");
      throw "exception caught IN getComments $error";
    }
  }

  /** send email **/
  @override
  Future<BaseResponse>? sendEmailData(
      String email, String subject, String comment) async {
    try {
      var map = {"email_id": email, "subject": subject, "comment": comment};

      map.addAll({
        "task": "sent_user_email",
        'client_id': await SharedPref.instance.getClientId(),
      });

      // map.addAll({
      //   'task': "feedback_report_list",
      //   'user_id': await SharedPref.instance.getUserId()
      // });

      var response =
          await NetworkClient().dio.post(base_url,queryParameters: map, data: FormData.fromMap(map));

      if (response.statusCode == 200) {
        var data = BaseResponse.fromJson(json.decode(response.data));

        return data;
      } else {
        throw "${response.statusCode} received from Server.\n\n Response => ${response.statusMessage}";
      }
    } on DioException catch (error) {
      log("EXCEPTION IN sendEmailData ${error.response}");
      throw "exception caught IN sendEmailData $error";
    }
  }
}
