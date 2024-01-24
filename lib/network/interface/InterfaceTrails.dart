import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/model/TrailPayload.dart';
import 'package:image_picker/image_picker.dart';

abstract class InterfaceTrails{
  Future<List<TrailPayload>> getTrails();

  Future<BaseResponse> submitTrailData(TrailPayload payload,XFile? trailImage,List<XFile>? galleryImages);

  Future<BaseResponse> updateTrailData(TrailPayload payload,XFile? trailImage,List<XFile>? galleryImages);

  Future<BaseResponse> submitOtherLanguageTrailData(TrailPayload payload);

  Future<TrailPayload> getTrailDetails(Map<String,String> params);

}