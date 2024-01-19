import '../../model/ClientUsers/ClientUserData.dart';

abstract class InterfaceClientUsers{
Future<List<ClientUserData>> getClientUserData(String task,String user_id);
}