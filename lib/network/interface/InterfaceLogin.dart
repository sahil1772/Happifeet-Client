
import 'package:happifeet_client_app/model/Login/LoginData.dart';

import '../../model/BaseResponse.dart';

abstract class InterfaceLogin{
  Future<LoginData> sendLoginDetails(String task, String username, String password);
  Future<BaseResponse> sendEmailIfForgotPassword(String task, String email);
  Future<BaseResponse> sendOtpToResetPassword(String task, String email,String otp);
  Future<BaseResponse> updateNewPassword(String task, String email,String newPassword);
}