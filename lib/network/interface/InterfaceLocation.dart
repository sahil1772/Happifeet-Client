
import 'package:happifeet_client_app/model/Location/LocationDataModel.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';

import '../../model/Location/LocationData.dart';

abstract class InterfaceLocation{
  Future<BaseResponse> submitLocationData(LocationDataModel data);

  Future<List<LocationData>> getLocationListService(String task);
}