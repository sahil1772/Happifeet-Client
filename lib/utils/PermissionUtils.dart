import 'package:permission_handler/permission_handler.dart';

class PermissionUtils{
  static Future<bool> permissionRequest() async {
    PermissionStatus result;
    result = await Permission.storage.request();
    if (result.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}