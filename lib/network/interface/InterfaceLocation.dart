
import 'package:happifeet_client_app/model/Location/LocationDataModel.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';

import '../../model/Location/LocationData.dart';

abstract class InterfaceLocation{

  Future<BaseResponse> deleteLocationData(String task,String park_id);
  Future<BaseResponse> updateLocationData(LocationDataModel data);
  Future<List<LocationDataModel>> editLocationData(String task,String park_id);
  Future<BaseResponse> submitLocationData(LocationDataModel data);
  Future<List<LocationData>?> getLocationListData(String task);
}