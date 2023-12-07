import '../../model/Announcement/AnnouncementData.dart';
import '../../model/BaseResponse.dart';

abstract class InterfaceAnnouncement{


  Future<List<AnnouncementData>> getAnnouncementList(String task, String user_id);
Future<BaseResponse> submitAnnouncementDetails(AnnouncementData data);
}