import 'package:happifeet_client_app/model/Login/LoginData.dart';

import '../../model/BaseResponse.dart';

abstract class InterfaceLogin{
  Future<BaseResponse> sendLoginDetails(String task, String username, String password);
  Future<BaseResponse> sendForgotPasswordDetails(String task, String username, String new_password);
}