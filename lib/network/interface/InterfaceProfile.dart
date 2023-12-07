
import '../../model/BaseResponse.dart';

abstract class InterfaceProfile{
  Future<BaseResponse> sendPasswordDetails(String task, String user_id, String oldPassword,String newPassword);
}