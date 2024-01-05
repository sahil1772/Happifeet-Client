import 'package:happifeet_client_app/model/BaseResponse.dart';

import '../../model/AssignedUsers/AssignedUserData.dart';

abstract class InterfaceUsers {
  Future<List<AssignedUserData>> getUserData(String client_id);

  Future<BaseResponse> deleteUserData(String task, String client_id);

  Future<BaseResponse> updateUserData(AssignedUserData data);

  Future<List<AssignedUserData>> editUserData(String task, String client_id);

  Future<BaseResponse> submitUserData(AssignedUserData data);
}
