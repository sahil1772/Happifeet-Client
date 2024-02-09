import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/components/DownloadProgressDialog.dart';
import 'package:happifeet_client_app/model/FilterMap.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/screens/Reports/FilterPage.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:happifeet_client_app/utils/DeviceDimensions.dart';
import 'package:happifeet_client_app/utils/PermissionUtils.dart';

import '../../components/HappiFeetAppBar.dart';
import '../../components/StatusCard.dart';
import '../../model/FeedbackStatus/FeedbackStatusData.dart';
import '../../storage/runtime_storage.dart';
import '../../utils/ColorParser.dart';
import 'StatusDetailPage.dart';
import 'StatusFilterpage.dart';

class StatusWidget extends StatefulWidget {
  const StatusWidget({super.key});

  gotoStatusPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const StatusWidget()));
  }

  @override
  State<StatusWidget> createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  List<FeedbackStatusData>? getStatusData;
  Future<List<FeedbackStatusData>>? apiResposne;
  int resolvedCount = 0;
  int pendingCount = 0;
  String totalFeedback = "0";

  String? selectedStatusID = "";


  FilterMap? filterParams = FilterMap(
      type: FilterType.Park.name,
      popupDatepickerToDateSearch:
      DateFormat("yyyy-MM-dd").format(DateTime.now()),
      popupDatepickerFromDateSearch:
      DateFormat("yyyy-MM-dd").format(DateTime.now()));

  @override
  void initState() {
    // TODO: implement initState
    apiResposne = getFeedbackStatusData();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double HEADER_HEIGHT = 4.5;
    return Scaffold(
      endDrawer: StatusDetailPage(report_id: selectedStatusID!),
      resizeToAvoidBottomInset: false,
      endDrawerEnableOpenDragGesture: false,
      extendBodyBehindAppBar: true,
      drawer: FilterPage(
          // showAssignedUser: true,
          // showType: true,
          // showStatus: true,
          // showKeyword: true,
          // formType: true,
          filterData: (params) {
            filterParams = params;
            apiResposne = getFeedbackStatusData();
          },
          params: filterParams, page: FilterPages.STATUS,),
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
                      "Status",
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
                                    prefixIcon: Builder(builder: (context) {
                                      return InkWell(
                                          onTap: () {
                                            Scaffold.of(context).openDrawer();
                                          },
                                          child: SvgPicture.asset(
                                            "assets/images/comments/filter.svg",
                                            colorFilter: ColorFilter.mode(
                                                ColorParser().hexToColor(
                                                    RuntimeStorage
                                                        .instance
                                                        .clientTheme!
                                                        .top_title_background_color!),
                                                BlendMode.srcIn),
                                          ));
                                    }),
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
                    Padding(
                      // padding: const EdgeInsets.symmetric(horizontal: 6),
                      padding:
                          const EdgeInsets.only(left: 6, right: 6, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: ColorParser().hexToColor("#F85100"),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    totalFeedback,
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    "Total",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  Text("Feedback",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: ColorParser().hexToColor("#C99700"),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    resolvedCount.toString(),
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    "Total",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    "Resolved",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: ColorParser().hexToColor("#FF9002"),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    pendingCount.toString(),
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    "Total",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    "Pending",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // OutlinedButton(
                          //     onPressed: () {},
                          //     // style: OutlinedButton.styleFrom(
                          //     //   // shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                          //     //   side: BorderSide(
                          //     //     color:  Resources.colors.buttonColorDark,
                          //     //   ),
                          //     // ),
                          //     style: ButtonStyle(
                          //       shape: MaterialStateProperty.all(
                          //           RoundedRectangleBorder(
                          //               borderRadius:
                          //                   BorderRadius.circular(10.0))),
                          //     ),
                          //     child: Row(
                          //       children: [
                          //         SvgPicture.asset(
                          //             "assets/images/status/pdf.svg"),
                          //         const SizedBox(
                          //           width: 10,
                          //         ),
                          //         const Text("Export to PDF"),
                          //       ],
                          //     )),
                          OutlinedButton(
                              onPressed: () async { bool result = await PermissionUtils.permissionRequest();
                              if (result) {

                                // widget.locationDetails!.qrImage != null
                                //     ? showDialog(
                                //     context: context,
                                //     builder: (dialogcontext) {
                                //       return DownloadProgressDialog(
                                //         filePath:
                                //         widget.locationDetails!.qrImage!,
                                //       );
                                //     })
                                //     :
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Failed to save data to device")));
                              } else {
                                print("No permission to read and write.");
                              }},
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ColorParser().hexToColor(RuntimeStorage
                                        .instance
                                        .clientTheme!
                                        .button_background!)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/status/excel.svg",
                                    colorFilter: ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "Export to Excel",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),

                    /**   listview builder     **/

                    /**  Comments card Listing **/

                    FutureBuilder<List<FeedbackStatusData>?>(
                      future: apiResposne,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return Flexible(
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                physics: const ScrollPhysics(),
                                itemCount: getStatusData!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return StatusCard(
                                    getStatusData: getStatusData![index],
                                    onClick: (value) {
                                      setState(() {
                                        print("Selected Report => $value");
                                        selectedStatusID = value;
                                        Scaffold.of(context).openEndDrawer();
                                      });
                                    },
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
                          } else {
                            return Text("Something Went Wrong!");
                          }
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

  Future<List<FeedbackStatusData>>? getFeedbackStatusData() async {
    var response = ApiFactory()
        .getFeedbackStatusService()
        .getFeedbackStatusListing(filterParams);
    getStatusData = await response;
    log("FEEDBACK STATUS DATA --> ${getStatusData!.first.toJson()}");
    if (getStatusData!.first.status == "Resolved") {
      resolvedCount++;
      log("resolvedCount${resolvedCount}");
    }
    if (getStatusData!.first.status == "Pending") {
      setState(() {
        pendingCount++;
      });
      log("pendingCount${pendingCount}");
    }
    setState(() {
      totalFeedback = getStatusData!.length.toString();
      log("totalFeedback${totalFeedback.toString()}");
    });
    return getStatusData!;
  }

}
