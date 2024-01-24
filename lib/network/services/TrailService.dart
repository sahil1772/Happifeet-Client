import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';

import 'package:happifeet_client_app/model/Trails/TrailPayload.dart';
import 'package:happifeet_client_app/network/interface/InterfaceTrails.dart';
import 'package:happifeet_client_app/network/services/ApiService.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';

import '../../model/Trails/TrailListingData.dart';

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


  /** GET TRAIL DATA FOR EDIT **/
  @override
  Future<TrailPayload> getTrailDetails(String? client_id) async {
    try {
      var map ={
        'task': "edit_trail",
        'client_id': await SharedPref.instance.getClientId(),

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


  /** GET TRAIL LISTING **/
  @override
  Future<List<TrailListingData>> getTrailListing(String? client_id) async {
    try {
      var map ={
        'task': "list_trail",
        'client_id': client_id,

      };

      var response = await NetworkClient()
          .dio
          .post(base_url, queryParameters:map);

      if (response.statusCode == 200) {

        List<TrailListingData> data = List<TrailListingData>.from(json
            .decode(response.data)
            .map((model) => TrailListingData.fromJson(model)));


        return data;
      } else {
        log("response other than 200 for getTrailListing");
        throw "response other than 200 for getTrailListing";
      }
    } on DioException catch (error) {
      log("EXCEPTION IN getTrailListing ${error.response}");
      throw error;
    }
  }



}
