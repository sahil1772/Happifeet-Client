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

  InterfaceSmtp getSmtpDetails(){
    if (_interfaceSmtp == null) {
      _interfaceSmtp = SmtpService();
    }
    return _interfaceSmtp!;
  }




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


