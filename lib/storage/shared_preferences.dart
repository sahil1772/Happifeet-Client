import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:happifeet_client_app/model/Login/AccessPermissionData.dart';
import 'package:happifeet_client_app/model/Login/UserData.dart';
import 'package:happifeet_client_app/storage/runtime_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/BottomNavigation.dart';
import '../model/Theme/ClientTheme.dart';
import '../model/Trails/TrailListingData.dart';
import '../screens/Login/LoginPage.dart';

class SharedPref {
  SharedPreferences? prefs;
  static final SharedPref instance = SharedPref._internal();

  SharedPref._internal();

  factory SharedPref() {
    return instance;
  }

  /// Store User data
  UserData userData = UserData();
  String? getuserData;
  ClientTheme? theme;

  setUserData(UserData userdata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log("data in setUserData ${userdata} ");
    userData = userdata;
    try {
      String user = json.encode(userdata);
      prefs.setString("userData", user);
    } catch (e) {
      throw e;
    }
  }



  Future<Map<String, dynamic>> getParks() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      return json.decode(preferences.getString("parks")!);
    } catch (e) {
      throw "Cannot Fetch Parks from session => ${e}";
    }
  }

  setParks(Map<String, dynamic> parks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      prefs.setString("parks", json.encode(parks));
    } catch (e) {
      throw e;
    }
  }

  Future<List<TrailListingData>> getTrails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      List<TrailListingData> data = List<TrailListingData>.from(json
              .decode(preferences.getString("trails")!)
              .map((model) => TrailListingData.fromJson(model)));
      return data;
    } catch (e) {
      throw "Cannot Fetch Trails from session => ${e}";
    }
  }

  setTrails(List<TrailListingData>? trails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      prefs.setString("trails", json.encode(trails));
    } catch (e) {
      throw e;
    }
  }

  setLanguages(Map<String, dynamic> languages) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      prefs.setString("languages", json.encode(languages));
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> getLanguageList() async {
    Map<String, dynamic> languages = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      languages = json.decode(prefs.getString("languages")!);
    } catch (e) {
      throw e;
    }

    return Future.value(languages);
  }

  Future<String> getUserName() async {
    String? Name = "";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      UserData data =
      UserData.fromJson(json.decode(prefs.getString("userData")!));
      log("User Name in Shared pref => ${data.theme_data}");
      Name = data.user_name;
    } catch (e) {
      throw e;
    }

    return Future.value(Name);
  }

  Future<String> getUserId() async {
    String? UserID = "";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      UserData data =
          UserData.fromJson(json.decode(prefs.getString("userData")!));
      log("User ID => ${data.user_id}");
      UserID = data.user_id;
    } catch (e) {
      throw e;
    }

    return Future.value(UserID);
  }

  Future<String> getClientId() async {
    String? ClientID = "";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      UserData data =
          UserData.fromJson(json.decode(prefs.getString("userData")!));
      log("Client ID => ${data.client_id}");
      ClientID = data.client_id;
    } catch (e) {
      throw e;
    }

    return Future.value(ClientID);
  }

  Future<String> getClientType() async {
    String? userType = "";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      UserData data =
          UserData.fromJson(json.decode(prefs.getString("userData")!));
      log("User Type => ${data.user_type}");
      userType = data.user_type;
    } catch (e) {
      throw e;
    }

    return Future.value(userType);
  }

  Future<UserData?> getUserData() async {
    UserData? data;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      getuserData = prefs.getString("userData");
      log("Fetched USer Data from Sessions =>  $getuserData");
      data = UserData.fromJson(json.decode(prefs.getString(getuserData!)!));
    } catch (e) {
      log("ERROR OCCURED ", error: e);
    }

    return Future.value(data);
  }

  /// Access permission
  AccessPermissionData accessPermission = AccessPermissionData();

  setAccessPermission(AccessPermissionData userdata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log("data in setAccessPermission ${userdata} ");
    accessPermission = AccessPermissionData.fromJson(userdata.toJson());

    prefs?.setString("accessPermission", accessPermission.toString());
  }

  AccessPermissionData getAccessPermission() {
    return this.accessPermission;
  }

  getPermissionAnnouncment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? data = (prefs.getBool("announcement") ?? false);
    log("inside getPermissionAnnouncment $data");
    return data;
  }

  getPermissionParkInspection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? data = (prefs.getBool("parkInspection") ?? false);
    log("inside getPermissionParkInspection $data");
    return data;
  }

  getPermissionActivityReport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? data = (prefs.getBool("activityReport") ?? false);
    log("inside getPermissionActivityReport $data");

    return data;
  }

  Future<bool?> getPermissionTrail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? data = (prefs.getBool("trail") ?? false);
    log("inside getPermissionTrail $data");
    return data;
  }

  logOutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

  }

  /// Session management

  Future checkIfLoggedIn(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = (prefs.getBool('loggedIn') ?? false);
    // bool? _seen = await prefs.setBool('seen',false);
    log("VALUE OF isLogin $isLogin");

    if (isLogin) {
      log("Current Theme in Session => ${prefs.getString("current_city_theme") ==null?" IS NULL ":prefs.getString("current_city_theme")}");
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context)));

      if (prefs.getString("current_city_theme") != null ) {
        RuntimeStorage.instance.clientTheme = ClientTheme.fromJson(
            json.decode(prefs.getString("current_city_theme")!));

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavigationHappiFeet(),
            ));
      } else{
        SharedPref.instance.logOutUser();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPageWidget(),
            ));
      }


    } else {
      // await prefs.setBool('seen', true);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPageWidget(),
          ));

    }
    return Future.value(isLogin);

  }

  ClientTheme clientTheme = ClientTheme();
  ClientTheme getClientTheme = ClientTheme();

  createTheme(String key, String values) {
    switch (key) {
      case "background_color":
        clientTheme.background_color = values;
        break;
      case "button_background":
        clientTheme.button_background = values;
        break;
      case "button_text_color":
        clientTheme.button_text_color = values;
        break;
      case "search_filter_border":
        clientTheme.search_filter_border = values;
        break;
      case "top_title_background_color":
        clientTheme.top_title_background_color = values;
        break;
      case "top_title_background_color_second":
        clientTheme.top_title_background_color_second = values;
        break;
      case "top_title_text_color":
        clientTheme.top_title_text_color = values;
        break;
      case "title_color_on_listing":
        clientTheme.title_color_on_listing = values;
        break;
      case "body_text_color":
        clientTheme.body_text_color = values;
        break;
      case "menu_active_color":
        clientTheme.menu_active_color = values;
        break;
      case "thank_you_image_color":
        clientTheme.thank_you_image_color = values;
        break;
      case "text_color":
        clientTheme.text_color = values;
        break;
      case "thank_you_page_message":
        clientTheme.thank_you_page_message = values;
        break;
    }
  }

  Future<ClientTheme> getCityTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    clientTheme = ClientTheme.fromJson(
        json.decode(prefs.getString("current_city_theme")!));

    // getClientTheme = ClientTheme.fromJson(json.decode(prefs.getString("current_city_theme")!));

    log(" GET CLIENT THEME -->> ${this.clientTheme.toJson()}");

    return this.clientTheme;
  }

  saveTheme(Map<String, dynamic> value) async {
    log("type of data ${value.runtimeType}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log("DATA IN saveTheme ${value['text_color']}");

    clientTheme = ClientTheme.fromJson(value);
    log("SAVE THEME -->> ${clientTheme.toJson()}");
    prefs.setString("current_city_theme", json.encode(clientTheme));
    RuntimeStorage.instance.clientTheme = ClientTheme.fromJson(
        json.decode(prefs.getString("current_city_theme")!));
    log("save theme in runtime at logged in${RuntimeStorage.instance.clientTheme!.toJson()}");
    // log("CURRENT THEME ${(prefs.get("current_city_theme") as CityTheme).toJson()}");
  }

  getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log("PRINT CURRENT THEME ${prefs.get("current_theme")}");

    return prefs.getString("current_city_theme");
  }
}
