import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/model/TrailPayload.dart';

abstract class InterfaceTrails{
  Future<List<TrailPayload>> getTrails();

  Future<BaseResponse> submitTrailData(TrailPayload payload);

  Future<BaseResponse> submitOtherLanguageTrailData(TrailPayload payload);

  Future<TrailPayload> getTrailDetails(String? trailId);

}