import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:happifeet_client_app/utils/DeviceDimensions.dart';

import '../../components/HappiFeetAppBar.dart';
import '../../components/StatusCard.dart';
import '../../model/FeedbackStatus/FeedbackStatusData.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    apiResposne = getFeedbackStatusData();

    super.initState();
  }

  Future<List<FeedbackStatusData>>? getFeedbackStatusData() async {
    var response = ApiFactory()
        .getFeedbackStatusService()
        .getFeedbackStatusListing("feedback_status_report_list",
            await SharedPref.instance.getUserId());
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

  @override
  Widget build(BuildContext context) {
    double HEADER_HEIGHT = 4;
    return Scaffold(
      endDrawer: StatusDetailPage(report_id: selectedStatusID!),
      resizeToAvoidBottomInset: false,
      endDrawerEnableOpenDragGesture: false,
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
                    ColorParser().hexToColor("#34A846"),
                    ColorParser().hexToColor("#83C03D")
                  ],
                )),
                child: Container(
                  margin: DeviceDimensions.getHeaderEdgeInsets(context),
                  child: const Center(
                    child: Text(
                      "Status",
                      // "Select Location".tr(),
                      // "Select Location".language(context),
                      // widget.selectedLanguage == "1" ? 'Select Location'.language(context) : 'Select Location',
                      style: TextStyle(
                          color: Colors.white,
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
                                            "assets/images/comments/filter.svg")),
                                    prefixIconConstraints: const BoxConstraints(
                                        minHeight: 30, minWidth: 60),
                                    prefixIconColor:
                                        ColorParser().hexToColor("#1A7C52"),
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
                              onPressed: () {},
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ColorParser().hexToColor("#49AC43")),
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

  Route _createRouteForFliterPage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          StatusFilterpageWidget(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;
        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );
        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}
