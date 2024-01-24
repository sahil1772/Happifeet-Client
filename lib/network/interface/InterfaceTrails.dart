import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/model/Trails/TrailPayload.dart';

import '../../model/Trails/TrailListingData.dart';

abstract class InterfaceTrails{
  Future<List<TrailPayload>> getTrails();

  Future<BaseResponse> submitTrailData(TrailPayload payload);

  Future<BaseResponse> submitOtherLanguageTrailData(TrailPayload payload);

  Future<TrailPayload> getTrailDetails(String? trailId);

  Future<List<TrailListingData>> getTrailListing(String? client_id);

}