
import 'package:happifeet_client_app/model/Location/LocationData.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';

abstract class InterfaceLocation{
  Future<BaseResponse> submitLocationData(LocationData data);
}