import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils{
  static Future<bool> permissionRequest() async {
    PermissionStatus result;
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if(int.parse(androidInfo.version.release)>12){

         if (await Permission.photos.request().isGranted && await Permission.videos.request().isGranted) {
           return true;
         } else {
           return false;
         }
      }
      else{
        result = await Permission.storage.request();
        if (result.isGranted) {
          return true;
        } else {
          return false;
        }
      }
    }
    else{
      result = await Permission.storage.request();
      if (result.isGranted) {
        return true;
      } else {
        return false;
      }
    }

  }
}