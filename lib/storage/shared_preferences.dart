import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/Theme/ClientTheme.dart';

class SharedPref {
  SharedPreferences? prefs;
  static final SharedPref instance = SharedPref._internal();

  SharedPref._internal();

  factory SharedPref() {
    return instance;
  }


  ClientTheme clientTheme = new ClientTheme();

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
    return this.clientTheme;
  }

  saveTheme(Map<String, dynamic> value) async {
    Map<String, dynamic> data;
    log("type of data ${value.runtimeType}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log("DATA IN saveTheme ${value['text_color']}");


    clientTheme = ClientTheme.fromJson(value);

    prefs.setString("current_city_theme", clientTheme.toString());


    // log("CURRENT THEME ${(prefs.get("current_city_theme") as CityTheme).toJson()}");



  }

}


