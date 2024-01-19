
import 'package:happifeet_client_app/model/Location/Features.dart';
import 'package:happifeet_client_app/model/Location/LocationDataModel.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/Location/LocationData.dart';

abstract class InterfaceLocation{

  Future<BaseResponse> deleteLocationData(String task,String park_id);
  Future<LocationDataModel> editLocationData(Map<String,String> park_id);
  Future<BaseResponse> submitLocationData(LocationDataModel data, XFile? locationImage, List<XFile>? galleryImages);
  Future<BaseResponse> updateLocationData(LocationDataModel data, XFile? locationImage, List<XFile>? galleryImages);
  Future<BaseResponse> submitLocationLanguageData(LocationDataModel data,String parkId,String language );
  Future<List<LocationData>?> getLocationListData(String task);

  Future<List<Features>?> getFeatures();
}