import 'package:image_picker/image_picker.dart';

import '../../model/Announcement/AnnouncementData.dart';
import '../../model/BaseResponse.dart';

abstract class InterfaceAnnouncement {
  Future<List<AnnouncementData>> getAnnouncementList(
      String task, String client_id);

  Future<BaseResponse> submitAnnouncementDetails(AnnouncementData data,XFile? announcmentImage);

  Future<BaseResponse> submitOtherLanguageAnnouncementDetails(AnnouncementData data);
}
