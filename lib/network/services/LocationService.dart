import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/model/Location/Features.dart';
import 'package:happifeet_client_app/model/Location/LocationDataModel.dart';
import 'package:happifeet_client_app/network/interface/InterfaceLocation.dart';
import 'package:happifeet_client_app/network/services/ApiService.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/Location/LocationData.dart';

class LocationService implements InterfaceLocation {
  /** Delete location data **/

  Future<BaseResponse> deleteLocationData(String park_id) async {
    try {
      var map = {"task": "delete_location", "park_id": park_id};

      var response =
          await NetworkClient().dio.post(base_url, data: FormData.fromMap(map));

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
      log("EXCEPTION IN deleteLocationData ${error.response}");
      throw "exeption caught IN deleteLocationData";
    }
  }

  /** Edit Location Data **/

  @override
  Future<LocationDataModel> editLocationData(Map<String, String> map) async {
    try {
      map.addAll({'task': "edit_location"});

      var response = await NetworkClient()
          .dio
          .get(base_url, queryParameters: map, data: FormData.fromMap(map));

      if (response.statusCode == 200) {
        LocationDataModel data =
            LocationDataModel.fromJson(json.decode(response.data!));

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

  /** Submit location data **/
  @override
  Future<BaseResponse> submitLocationData(LocationDataModel data,
      XFile? locationImage, List<XFile>? galleryImages) async {
    //Converting LocationData Object to Map<String,dynamic>
    Map<String, dynamic> paramMap = data.toJson();
    //Adding task to Map
    paramMap.addAll({"task": "submit_location"});
    paramMap.addAll({"user_id": await SharedPref.instance.getUserId()});
    paramMap.addAll({"parkFeatures": data.parkFeatures});

    var formData = FormData.fromMap(paramMap, ListFormat.multiCompatible);

    formData.files.add(MapEntry(
        "parkImages", await MultipartFile.fromFile(locationImage!.path)));

    for (var file in galleryImages!) {
      formData.files.add(
        MapEntry("galleryImages[${galleryImages!.indexOf(file)}]",
            await MultipartFile.fromFile(file.path)),
      );
    }
    log("PARAM MAP $formData");

    // var  paramMap = {"task":task};

    //Calling Post API
    var response = await NetworkClient().dio.post(base_url, data: formData);

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
  }

  /** get Location data **/
  @override
  Future<List<LocationData>?> getLocationListData(String task) async {
    try {
      var map = {
        'task': task,
        'client': await SharedPref.instance.getUserId(),
      };

      var response =
          await NetworkClient().dio.post(base_url, data: FormData.fromMap(map));
      log("this is response of LocationData  ${response}");

      if (response.statusCode == 200) {
        List<LocationData> data = List<LocationData>.from(json
            .decode(response.data)
            .map((model) => LocationData.fromJson(model)));
        log(
          "response done for getLocationListService ${data.toString()}",
        );
        return data;
      } else {
        log("response other than 200 for LocationData");
        throw "response other than 200 for LocationData";

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

  @override
  Future<List<Features>?> getFeatures() async {
    try {
      var map = {
        'task': "getfeatures",
      };

      var response =
          await NetworkClient().dio.post(base_url, queryParameters: map);

      if (response.statusCode == 200) {
        List<Features> data = List<Features>.from(json
            .decode(response.data)
            .map((model) => Features.fromJson(model)));

        return data;
      } else {
        throw "response other than 200 for getFeatures";
      }
    } on DioException catch (error) {
      throw "exeption caught IN getFeatures";
      log("ERROR OCCURED ON FUCTION CALL getFeatures $error");
    }
  }

  @override
  Future<BaseResponse> submitLocationLanguageData(
      LocationDataModel data,
      String parkId,
      String lang,
      XFile? locationImage,
      List<XFile>? galleryImages) async {
    Map<String, dynamic> paramMap = data.toJson();

    paramMap.addAll({"task": "update_location_lang"});
    paramMap.addAll({"user_id": await SharedPref.instance.getUserId()});
    paramMap.addAll({"park_id": parkId});
    paramMap.addAll({"id": parkId});
    paramMap.addAll({"lang": lang});
    paramMap.removeWhere((key, value) => value == null||value=="");
    var formData = FormData.fromMap(paramMap, ListFormat.multiCompatible);
    if (locationImage != null) {
      formData.files.add(MapEntry(
          "parkImages", await MultipartFile.fromFile(locationImage!.path)));
    }

    if (galleryImages != null && galleryImages.isNotEmpty) {
      for (var file in galleryImages!) {
        formData.files.add(
          MapEntry("galleryImages[${galleryImages!.indexOf(file)}]",
              await MultipartFile.fromFile(file.path)),
        );
      }
    }
    log("PARAM MAP $formData");

    //Calling Post API
    var response = await NetworkClient().dio.post(base_url, data: formData);

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
  }

  @override
  Future<BaseResponse> updateLocationData(LocationDataModel data,
      XFile? locationImage, List<XFile>? galleryImages) async {

    Map<String, dynamic> paramMap = data.toJson();
    paramMap.removeWhere((key, value) => value == null || value == "");
    //Adding task to Map
    paramMap.addAll({"task": "update_location"});
    paramMap.addAll({"user_id": await SharedPref.instance.getUserId()});
    paramMap.addAll({"parkFeatures": data.parkFeatures});

    var formData = FormData.fromMap(paramMap, ListFormat.multiCompatible);

    if (locationImage != null) {
      formData.files.add(MapEntry(
          "parkImages", await MultipartFile.fromFile(locationImage!.path)));
    }

    if (galleryImages != null && galleryImages.isNotEmpty) {
      for (var file in galleryImages!) {
        formData.files.add(
          MapEntry("galleryImages[${galleryImages!.indexOf(file)}]",
              await MultipartFile.fromFile(file.path)),
        );
      }
    }
    log("PARAM MAP ${formData.fields}");

    // var  paramMap = {"task":task};

    //Calling Post API
    var response = await NetworkClient().dio.post(base_url, data: formData);

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
  }

  @override
  Future<BaseResponse> deleteImage(Map<String, dynamic> params) async {
    Map<String, dynamic> paramMap = params;
    paramMap.removeWhere((key, value) => value == null || value == "");
    //Adding task to Map
    paramMap.addAll({"task": "delete_location_image"});
    paramMap.addAll({"user_id": await SharedPref.instance.getUserId()});

    //Calling Post API
    var response = await NetworkClient().dio.post(base_url, data: FormData.fromMap(paramMap));

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
  }
}
