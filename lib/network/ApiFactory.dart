import 'package:happifeet_client_app/network/interface/InterfaceLocation.dart';
import 'package:happifeet_client_app/network/services/LocationService.dart';
import 'package:happifeet_client_app/network/services/LoginService.dart';
import 'package:happifeet_client_app/network/services/SmtpService.dart';

import 'interface/interface_login.dart';
import 'interface/interface_smtp.dart';

class ApiFactory {
  ApiFactory._privateConstructor();

  static final ApiFactory _instance = ApiFactory._privateConstructor();

  factory ApiFactory() {
    return _instance;
  }

  InterfaceLogin? _interfaceLogin;
  InterfaceSmtp? _interfaceSmtp;
  InterfaceLocation? _interfaceLocation;

  InterfaceSmtp getSMTPService() {
    _interfaceSmtp ??= SmtpService();
    return _interfaceSmtp!;
  }

  InterfaceLocation getLocationService() {
    _interfaceLocation ??= LocationService();
    return _interfaceLocation!;
  }

  InterfaceLogin getLoginService() {
    _interfaceLogin ??= LoginService();
    return _interfaceLogin!;
  }
}
