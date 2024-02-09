import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/model/Comments/CommentData.dart';
import 'package:happifeet_client_app/model/FilterMap.dart';

abstract class InterfaceComments {
  Future<List<CommentData>>? getComments(FilterMap? params);
  Future<BaseResponse>? sendEmailData(String email, String subject, String comment);
}
