

import 'package:json_annotation/json_annotation.dart';

part 'ClientTheme.g.dart';

@JsonSerializable()



class ClientTheme{
  String? logo;
  String? background_color;
  String? button_background;
  String? button_text_color;
  String? search_filter_border;
  String? top_title_background_color;
  String? top_title_background_color_second;
  String? top_title_text_color;
  String? title_color_on_listing;
  String? body_text_color;
  String? menu_active_color;
  String? thank_you_image_color;
  String? text_color;
  String? thank_you_page_message;


  ClientTheme({
    this.logo,
    this.background_color,
    this.button_background,
    this.button_text_color,
    this.search_filter_border,
    this.top_title_background_color,
    this.top_title_background_color_second,
    this.top_title_text_color,
    this.title_color_on_listing,
    this.body_text_color,
    this.menu_active_color,
    this.thank_you_image_color,
    this.text_color,
    this.thank_you_page_message

});


  factory ClientTheme.fromJson(Map<String,dynamic> json) => _$ClientThemeFromJson(json);

  Map<String, dynamic> toJson() => _$ClientThemeToJson(this);


}