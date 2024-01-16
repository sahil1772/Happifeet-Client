
import '../../model/BaseResponse.dart';

abstract class InterfaceLogin{
  Future<BaseResponse> sendLoginDetails(String task, String username, String password);
  Future<BaseResponse> sendEmailIfForgotPassword(String task, String email);
}