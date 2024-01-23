import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';

import 'package:happifeet_client_app/model/TrailPayload.dart';
import 'package:happifeet_client_app/network/interface/InterfaceTrails.dart';
import 'package:happifeet_client_app/network/services/ApiService.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';

class TrailService implements InterfaceTrails {
  @override
  Future<List<TrailPayload>> getTrails() async {
    try {
      var map = {'task': "edit_location"};

      var response = await NetworkClient()
          .dio
          .get(base_url, queryParameters: map, data: FormData.fromMap(map));

      if (response.statusCode == 200) {
        List<TrailPayload> data = List.from(json
            .decode(response.data)
            .map((model) => TrailPayload.fromJson((model))));

        return data;
      } else {
        log("response other than 200 for LocationData");
        throw "response other than 200 for LocationData";
      }
    } on DioException catch (error) {
      log("EXCEPTION IN editLocationData ${error.response}");
      throw error;
    }
  }

  @override
  Future<BaseResponse> submitTrailData(TrailPayload payload) async {
    try {
      var map = payload.toJson();
      map.addAll({
        'task': "submit_trail",
        'user_id': await SharedPref.instance.getUserId()
      });

      var response = await NetworkClient()
          .dio
          .post(base_url, data: FormData.fromMap(map));

      if (response.statusCode == 200) {
        BaseResponse data = BaseResponse.fromJson(json.decode(response.data!));

        return data;
      } else {
        log("response other than 200 for LocationData");
        throw "response other than 200 for LocationData";
      }
    } on DioException catch (error) {
      log("EXCEPTION IN editLocationData ${error.response}");
      throw error;
    }
  }

  @override
  Future<BaseResponse> submitOtherLanguageTrailData(TrailPayload payload) async {
    try {
      var map = payload.toJson();
      map.addAll({
        'task': "update_trail_lang",
        'user_id': await SharedPref.instance.getUserId()
      });

      var response = await NetworkClient()
          .dio
          .post(base_url, data: FormData.fromMap(map));

      if (response.statusCode == 200) {
        BaseResponse data = BaseResponse.fromJson(json.decode(response.data!));

        return data;
      } else {
        log("response other than 200 for LocationData");
        throw "response other than 200 for LocationData";
      }
    } on DioException catch (error) {
      log("EXCEPTION IN editLocationData ${error.response}");
      throw error;
    }
  }

  @override
  Future<TrailPayload> getTrailDetails(String? trailId) async {
    try {
      var map ={
        'task': "edit_trail",
        'client_id': await SharedPref.instance.getUserId(),
        'trail_id': trailId,
      };

      var response = await NetworkClient()
          .dio
          .post(base_url, data: FormData.fromMap(map));

      if (response.statusCode == 200) {
        TrailPayload data = TrailPayload.fromJson(json.decode(response.data!));

        return data;
      } else {
        log("response other than 200 for LocationData");
        throw "response other than 200 for LocationData";
      }
    } on DioException catch (error) {
      log("EXCEPTION IN editLocationData ${error.response}");
      throw error;
    }
  }
}
