import 'package:happifeet_client_app/model/Login/LoginData.dart';

import '../../model/SuccessResponse.dart';

abstract class InterfaceLogin{
  Future<SuccessResponse> sendLoginDetails(String task, String username, String password);
  Future<SuccessResponse> sendForgotPasswordDetails(String task, String username, String new_password);
}