import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/model/ActivityReport/ActivityReportData.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';

import '../../../components/ActivityReportCard.dart';
import '../../../components/HappiFeetAppBar.dart';
import '../../../storage/runtime_storage.dart';
import '../../../storage/shared_preferences.dart';
import '../../../utils/ColorParser.dart';
import '../../../utils/DeviceDimensions.dart';

class ActivityReportWidget extends StatefulWidget {
  gotoActivityReport(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => ActivityReportWidget()));
  }

  @override
  State<ActivityReportWidget> createState() => _ActivityReportWidgetState();
}

class _ActivityReportWidgetState extends State<ActivityReportWidget> {
  List<ActivityReportData>? activityReportData;
  Future<List<ActivityReportData>>? apiResponse;

  @override
  void initState() {
    // TODO: implement initState
    apiResponse = getActivityReportListing();
    super.initState();
  }

  Future<List<ActivityReportData>>? getActivityReportListing() async {
    var response = ApiFactory()
        .getActivityReportService()
        .getActivityReportListing(
            "activity_report_list", await SharedPref.instance.getUserId());
    activityReportData = await response;
    log("ACTIVITY REPORT DATA --> ${activityReportData!.first.toJson()}");
    return activityReportData!;
  }

  @override
  Widget build(BuildContext context) {
    double HEADER_HEIGHT = 4.5;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: HappiFeetAppBar(IsDashboard: false, isCitiyList: false)
          .getAppBar(context),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Container(
                height: DeviceDimensions.getHeaderSize(context, HEADER_HEIGHT),
                width: DeviceDimensions.getDeviceWidth(context),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ColorParser().hexToColor(RuntimeStorage
                        .instance.clientTheme!.top_title_background_color!),
                    ColorParser().hexToColor(RuntimeStorage
                        .instance.clientTheme!.top_title_background_color!),
                  ],
                )),
                child: Container(
                  margin: DeviceDimensions.getHeaderEdgeInsets(context),
                  child: Center(
                    child: Text(
                      "Activity Report",
                      // "Select Location".tr(),
                      // "Select Location".language(context),
                      // widget.selectedLanguage == "1" ? 'Select Location'.language(context) : 'Select Location',
                      style: TextStyle(
                          color: ColorParser().hexToColor(RuntimeStorage
                              .instance.clientTheme!.top_title_text_color!),
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )),
            Container(
              margin: EdgeInsets.only(
                  top: DeviceDimensions.getBottomSheetMargin(
                      context, HEADER_HEIGHT)),
              height:
                  DeviceDimensions.getBottomSheetHeight(context, HEADER_HEIGHT),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                  color: Colors.white),
              // color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /** Search bar **/
                    Padding(
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: 8, vertical: 26),

                      padding: const EdgeInsets.only(
                          left: 8, top: 20, right: 8, bottom: 20),
                      child: Row(
                        children: [
                          Flexible(
                            child: SizedBox(
                              height: 50,
                              width: 400,
                              child: TextField(
                                  onChanged: (value) {
                                    // filterSearchResults(value);
                                  },
                                  style: const TextStyle(fontSize: 16),
                                  decoration: InputDecoration(
                                    prefixIcon: InkWell(
                                        onTap: () {},
                                        child: SvgPicture.asset(
                                          "assets/images/comments/filter.svg",
                                          colorFilter: ColorFilter.mode(
                                              ColorParser().hexToColor(
                                                  RuntimeStorage
                                                      .instance
                                                      .clientTheme!
                                                      .top_title_background_color!),
                                              BlendMode.srcIn),
                                        )),
                                    prefixIconConstraints: const BoxConstraints(
                                        minHeight: 30, minWidth: 60),
                                    // prefixIconColor:
                                    //     ColorParser().hexToColor("#1A7C52"),
                                    labelText: ' Filters',
                                    // labelText: widget.selectedLanguage == "1"
                                    //     ? "Search".language(context)
                                    //     : "Search",
                                    labelStyle: TextStyle(
                                        color: ColorParser()
                                            .hexToColor("#9E9E9E")),

                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color: Colors.grey,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /**   listview builder     **/

                    /**  Activity Report **/

                    FutureBuilder<List<ActivityReportData>?>(
                      future: apiResponse,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Flexible(
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              physics: const ScrollPhysics(),
                              itemCount: activityReportData!.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ActivityReportCard(
                                  activityReportData:
                                      activityReportData![index],
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(
                                  height: 8,
                                );
                              },
                            ),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else {
                          return Text("Something Went Wrong");
                        }
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
