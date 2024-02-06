import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/resources/resources.dart';
import 'package:happifeet_client_app/screens/Manage/ManageActivityReport/ActivityReportListing.dart';
import 'package:happifeet_client_app/screens/Manage/ManageAnnouncements/AnnouncementListing.dart';
import 'package:happifeet_client_app/screens/Manage/ManageClients/ClientListing.dart';
import 'package:happifeet_client_app/screens/Manage/ManageLocation/LocationListing.dart';
import 'package:happifeet_client_app/screens/Manage/ManageSMTP/manage_smtp_details.dart';
import 'package:happifeet_client_app/screens/Manage/ManageTrails/TrailListing.dart';
import 'package:happifeet_client_app/storage/runtime_storage.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../components/HappiFeetAppBar.dart';
import '../../model/Theme/ClientTheme.dart';
import '../../utils/ColorParser.dart';
import '../../utils/DeviceDimensions.dart';
import 'ManageUsers/AssignedUserListing.dart';

class ManageWidget extends StatefulWidget {
  ClientTheme? clientTheme;
  PersistentTabController? controller;

  ManageWidget({super.key, this.clientTheme,this.controller});

  @override
  State<ManageWidget> createState() => _ManageWidgetState();
}

class _ManageWidgetState extends State<ManageWidget> {
  // List<PermissionData> data = new PermissionData() as List<PermissionData>;
  bool? isAnnouncement = false;
  bool? isparkInspection = false;
  bool? isactivityReport = false;
  bool? istrail = false;
  ClientTheme? theme;

  Future<void> checkPermissions() async {
    isAnnouncement = await SharedPref.instance.getPermissionAnnouncment();
    isparkInspection = await SharedPref.instance.getPermissionParkInspection();
    isactivityReport = await SharedPref.instance.getPermissionActivityReport();
    istrail = await SharedPref.instance.getPermissionTrail();

    log("value of isAnnouncement $isAnnouncement");
    log("value of isparkInspection $isparkInspection");
    log("value of isactivityReport $isactivityReport");
    log("value of istrail $istrail");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    // checkPermissions();
    // SharedPref.instance.setPermissions();
    log("BOTTOMSHEET CONTROLLER IN MANAGE PAGE ${widget.controller}");

    SharedPref.instance.getCityTheme().then((value) {
      theme = value;
      checkPermissions();
    });

    super.initState();
  }

  // checkPermissions()  async{
  //   log("DATAAAAA ${await SharedPref.instance.getPermissionlocation()}");
  //   if(await SharedPref.instance.getPermissionlocation()){
  //     data.name = "Manage Location";
  //     data.img = "assets/images/manage/location.svg";
  //   } if( await SharedPref.instance.getPermissionUser()){
  //     data.name = "Manage Users";
  //     data.img = "assets/images/manage/users.svg";
  //   } if(await SharedPref.instance.getPermissionAnnouncement()){
  //     data.name = "Manage Announcement";
  //     data.img = "assets/images/manage/announcement.svg";
  //   } if(await SharedPref.instance.getPermissionSmtp()){
  //     data.name = "Manage SMTP Details";
  //     data.img = "assets/images/manage/smtp.svg";
  //   }
  //   log("AFTER ADDING DATA ${data!.toJson()}");
  // }

  @override
  Widget build(BuildContext context) {
    double HEADER_AREA = 3.5;
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: HappiFeetAppBar(IsDashboard: true, isCitiyList: false)
          .getAppBar(context),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Container(
                height: DeviceDimensions.getHeaderSize(context, HEADER_AREA),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    ColorParser().hexToColor(RuntimeStorage
                        .instance.clientTheme!.top_title_background_color!),
                    ColorParser().hexToColor(RuntimeStorage
                        .instance.clientTheme!.top_title_background_color!)
                  ],
                )),
                child: Container(
                  margin: DeviceDimensions.getHeaderEdgeInsets(context),
                  child:  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Manage",
                        // "Select Location".tr(),
                        // "Select Location".language(context),
                        // widget.selectedLanguage == "1" ? 'Select Location'.language(context) : 'Select Location',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_text_color!)),
                      ),
                    ),
                  ),
                )),
            Positioned(
                right: MediaQuery.of(context).size.height <= 667 ? -25 : 0,
                top: MediaQuery.of(context).size.height <= 667
                    ? MediaQuery.of(context).size.height / 7.7
                    : MediaQuery.of(context).size.height / 9.5,
                child: SizedBox(
                    height:
                        MediaQuery.of(context).size.height <= 667 ? 140 : null,
                    child: SvgPicture.asset(
                      "assets/images/manage/manageBG.svg",
                    ))),
            Container(
              height:
                  DeviceDimensions.getBottomSheetHeight(context, HEADER_AREA),
              margin: EdgeInsets.only(
                  top: DeviceDimensions.getBottomSheetMargin(
                      context, HEADER_AREA)),
              padding: const EdgeInsets.symmetric(horizontal: 0),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                  color: Colors.white),
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 22),
                  child: Column(
                    children: [
                      GridView(
                        padding: const EdgeInsets.all(0),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 180,
                                // childAspectRatio: (itemWidth / itemHeight),
                                childAspectRatio: 1,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        children: [
                          InkWell(
                            onTap: () {
                              LocationListing().gotoManageLocation(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(14))),
                              width: 150,
                              height: 130,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        color: ColorParser().hexToColor(
                                            RuntimeStorage.instance.clientTheme!
                                                .top_title_background_color!),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: SvgPicture.asset(
                                        "assets/images/manage/location.svg",
                                        colorFilter: ColorFilter.mode(
                                            Colors.white, BlendMode.srcIn),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text("Manage \nLocation",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Resources.colors.hfText),
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              const AssignedUserListing()
                                  .goToAssignedUserListing(context, null);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(14),
                                  )),
                              width: 150,
                              height: 130,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        color: ColorParser().hexToColor(
                                            RuntimeStorage.instance.clientTheme!
                                                .top_title_background_color!),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: SvgPicture.asset(
                                        "assets/images/manage/users.svg",
                                        colorFilter: ColorFilter.mode(
                                            Colors.white, BlendMode.srcIn),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text("Manage \nUsers",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Resources.colors.hfText),
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                          if (isAnnouncement!)
                            InkWell(
                              onTap: () {
                                AnnouncementListingWidget
                                    .gotoAnnouncementListingPage(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black12,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(14))),
                                width: 150,
                                height: 130,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          color: ColorParser().hexToColor(
                                              RuntimeStorage
                                                  .instance
                                                  .clientTheme!
                                                  .top_title_background_color!),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: SvgPicture.asset(
                                          "assets/images/manage/announcement.svg",
                                          colorFilter: ColorFilter.mode(
                                              Colors.white, BlendMode.srcIn),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("Manage \nAnnouncement",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Resources.colors.hfText),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ),
                          InkWell(
                            onTap: () {
                               ManageSMTPDetails()
                                  .goToManageSMTPPage(context,widget.controller);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(14),
                                  )),
                              width: 150,
                              height: 130,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        color: ColorParser().hexToColor(
                                            RuntimeStorage.instance.clientTheme!
                                                .top_title_background_color!),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: SvgPicture.asset(
                                        "assets/images/manage/smtp.svg",
                                        colorFilter: ColorFilter.mode(
                                            Colors.white, BlendMode.srcIn),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text("Manage \nSMTP Details",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Resources.colors.hfText),
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              ClientListingWidget()
                                  .gotoClientListingPage(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(14),
                                  )),
                              width: 150,
                              height: 130,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        color: ColorParser().hexToColor(
                                            RuntimeStorage.instance.clientTheme!
                                                .top_title_background_color!),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: SvgPicture.asset(
                                        "assets/images/manage/clientUser.svg",
                                        colorFilter: ColorFilter.mode(
                                            Colors.white, BlendMode.srcIn),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text("Manage Client Users",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Resources.colors.hfText),
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                          if (isparkInspection!)
                            InkWell(
                              onTap: () {
                                // ClientListingWidget()
                                //     .gotoClientListingPage(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black12),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(14),
                                    )),
                                width: 150,
                                height: 130,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          color: ColorParser().hexToColor(
                                              RuntimeStorage
                                                  .instance
                                                  .clientTheme!
                                                  .top_title_background_color!),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: SvgPicture.asset(
                                          "assets/images/manage/parkInspection.svg",
                                          colorFilter: ColorFilter.mode(
                                              Colors.white, BlendMode.srcIn),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("Park Inspection",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Resources.colors.hfText),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ),
                          if (isactivityReport!)
                            InkWell(
                              onTap: () {
                                // ClientListingWidget()
                                //     .gotoClientListingPage(context);
                                ActivityReportWidget().gotoActivityReport(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black12),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(14),
                                    )),
                                width: 150,
                                height: 130,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          color: ColorParser().hexToColor(
                                              RuntimeStorage
                                                  .instance
                                                  .clientTheme!
                                                  .top_title_background_color!),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: SvgPicture.asset(
                                          "assets/images/manage/activityReport.svg",
                                          colorFilter: ColorFilter.mode(
                                              Colors.white, BlendMode.srcIn),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("Activity Report",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Resources.colors.hfText),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ),
                          if (istrail!)
                            InkWell(
                              onTap: () {
                                TrailListing.goToTrailListing(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black12),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(14),
                                    )),
                                width: 150,
                                height: 130,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          color: ColorParser().hexToColor(
                                              RuntimeStorage
                                                  .instance
                                                  .clientTheme!
                                                  .top_title_background_color!),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: SvgPicture.asset(
                                            "assets/images/manage/manageTrail.svg"),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("Manage Trail",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Resources.colors.hfText),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
