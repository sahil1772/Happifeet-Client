import 'package:happifeet_client_app/network/services/LoginService.dart';

import 'interface/interface_login.dart';

class ApiFactory {
  ApiFactory._privateConstructor();

  static final ApiFactory _instance = ApiFactory._privateConstructor();

  factory ApiFactory() {
    return _instance;
  }
  InterfaceLogin? _interfaceLogin;



  InterfaceLogin sendForgotPasswordDetails(){
    if (_interfaceLogin == null) {
      _interfaceLogin = LoginService();
    }
    return _interfaceLogin!;
  }



  InterfaceLogin sendLoginDetails(){
    if (_interfaceLogin == null) {
      _interfaceLogin = LoginService();
    }
    return _interfaceLogin!;
  }





}


