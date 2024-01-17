
import 'package:dio/dio.dart';
import 'package:happifeet_client_app/model/DashboardModels/DashboardResponse.dart';

abstract class InterfaceDashboard{

  Future<Response?> getParkAnalytics(String? parkId,String? type);

  Future<Response?> getParks(String? client_user_id);

}