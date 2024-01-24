import 'package:happifeet_client_app/model/BaseResponse.dart';

import '../../model/ClientUsers/AddClientUser.dart';
import '../../model/ClientUsers/ClientUserData.dart';
import '../../model/ClientUsers/EditClientUser.dart';
import '../../model/ClientUsers/UpdateClientUser.dart';

abstract class InterfaceClientUsers{
Future<List<ClientUserData>> getClientUserData(String task,String user_id);
Future<BaseResponse> submitClientUserData(AddClientUser data);
Future<EditClientUser> editClientUserData(String task,String id);
Future<BaseResponse> updateClientUserData(UpdateClientUser data);
Future<BaseResponse> deleteClientUserData(String task, String id);
}