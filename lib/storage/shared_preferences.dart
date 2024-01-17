import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:happifeet_client_app/model/Login/AccessPermissionData.dart';
import 'package:happifeet_client_app/model/Login/UserData.dart';
import 'package:happifeet_client_app/screens/Dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/Theme/ClientTheme.dart';
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

  setUserData(UserData userdata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log("data in setUserData ${userdata} ");
    userData = userdata;
    try {
      String user = json.encode(userdata);
      prefs.setString("userData",user);

    } catch (e) {
      throw e;
    }
  }

  Future<String> getClientId() async {
    String? ClientID = "";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      UserData data = UserData.fromJson(json.decode(prefs.getString("userData")!));
      log("Client ID => ${data.user_id}");
      ClientID = data.user_id;
    } catch (e) {
      throw e;
    }

    return Future.value(ClientID);
  }

  getUserData() async {
    UserData? data;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      getuserData = prefs.getString("userData");
      log("Fetched User Data from Sessions =>  $getuserData");

      data = UserData.fromJson(json.decode(prefs.getString(getuserData!)!));
    } catch (e) {
      log("ERROR OCCURED ", error: e);
    }

    return data;
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

  /// Session management

  Future checkIfLoggedIn(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = (prefs.getBool('loggedIn') ?? false);
    // bool? _seen = await prefs.setBool('seen',false);
    log("VALUE OF isLogin $isLogin");

    if (isLogin) {
      log("inside LoggedIn");
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context)));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardWidget(),
              ));
    } else {
      // await prefs.setBool('seen', true);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPageWidget(),
          ));
    }
  }

  ClientTheme clientTheme = ClientTheme();

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

  ClientTheme getCityTheme() {
    return clientTheme;
  }

  saveTheme(Map<String, dynamic> value) async {
    log("type of data ${value.runtimeType}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log("DATA IN saveTheme ${value['text_color']}");

    clientTheme = ClientTheme.fromJson(value);

    prefs.setString("current_city_theme", clientTheme.toString());

    // log("CURRENT THEME ${(prefs.get("current_city_theme") as CityTheme).toJson()}");
  }
}
