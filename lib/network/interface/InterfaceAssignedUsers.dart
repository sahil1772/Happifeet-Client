import 'package:happifeet_client_app/model/AssignedUsers/UpdateAssignedUserData.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';

import '../../model/AssignedUsers/AssignedUserData.dart';
import '../../model/AssignedUsers/SubmitAssignedUserData.dart';

abstract class InterfaceAssignedUsers {
  Future<List<AssignedUserData>> getUserData(String task,String user_id);

  Future<BaseResponse> deleteUserData(String task, String client_id);

  Future<BaseResponse> updateUserData(UpdateAssignedUserData data);

  Future<AssignedUserData> editUserData(String task, String client_id);

  Future<BaseResponse> submitUserData(SubmitAssignedUserData data);
}
