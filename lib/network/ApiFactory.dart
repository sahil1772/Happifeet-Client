import 'package:happifeet_client_app/network/interface/InterfaceDashboard.dart';
import 'package:happifeet_client_app/network/interface/InterfaceLocation.dart';
import 'package:happifeet_client_app/network/interface/InterfaceTrails.dart';
import 'package:happifeet_client_app/network/services/AnnouncementService.dart';
import 'package:happifeet_client_app/network/services/AssignedUserService.dart';
import 'package:happifeet_client_app/network/services/ClientUserService.dart';
import 'package:happifeet_client_app/network/services/DashboardService.dart';
import 'package:happifeet_client_app/network/services/FeedbackService.dart';
import 'package:happifeet_client_app/network/services/LocationService.dart';
import 'package:happifeet_client_app/network/services/LoginService.dart';
import 'package:happifeet_client_app/network/services/ProfileService.dart';
import 'package:happifeet_client_app/network/services/SmtpService.dart';
import 'package:happifeet_client_app/network/services/TrailService.dart';

import 'interface/InrerfaceFeedback.dart';
import 'interface/InterfaceAnnouncement.dart';
import 'interface/InterfaceClientUsers.dart';
import 'interface/InterfaceLogin.dart';
import 'interface/InterfaceProfile.dart';
import 'interface/InterfaceSmtp.dart';
import 'interface/InterfaceAssignedUsers.dart';

class ApiFactory {
  ApiFactory._privateConstructor();

  static final ApiFactory _instance = ApiFactory._privateConstructor();

  factory ApiFactory() {
    return _instance;
  }

  InterfaceLogin? _interfaceLogin;
  InterfaceSmtp? _interfaceSmtp;
  InterfaceLocation? _interfaceLocation;
  InterfaceAssignedUsers? _interfaceUsers;
  InterfaceAnnouncement? _interfaceAnnouncement;
  InterfaceFeedback? _interfaceFeedback;
  InterfaceDashboard? _interfaceDashboard;
  InterfaceProfile? _interfaceProfile;
  InterfaceClientUsers? _interfaceClientUsers;
  InterfaceTrails? _interfaceTrails;

  InterfaceClientUsers getClientService() {
    _interfaceClientUsers ??= ClientUserService();
    return _interfaceClientUsers!;
  }

  InterfaceTrails getTrailService(){
    _interfaceTrails ??= TrailService();
    return _interfaceTrails!;
  }




  InterfaceProfile getProfileService() {
    _interfaceProfile ??= ProfileService();
    return _interfaceProfile!;
  }


  InterfaceDashboard getDashboardService() {
    _interfaceDashboard ??= DashboardService();
    return _interfaceDashboard!;
  }


  InterfaceFeedback getFeedbackService() {
    _interfaceFeedback ??= FeedbackService();
    return _interfaceFeedback!;
  }




  InterfaceAnnouncement getAnnouncementService() {
    _interfaceAnnouncement ??= AnnouncementService();
    return _interfaceAnnouncement!;
  }



  InterfaceAssignedUsers getUserService() {
    _interfaceUsers ??= AssignedUserService();
    return _interfaceUsers!;
  }



  InterfaceSmtp getSMTPService() {
    _interfaceSmtp ??= SmtpService();
    return _interfaceSmtp!;
  }

  InterfaceLocation getLocationService() {
    _interfaceLocation ??= LocationService();
    return _interfaceLocation!;
  }

  InterfaceLogin getLoginService() {
    _interfaceLogin ??= LoginService();
    return _interfaceLogin!;
  }
}
