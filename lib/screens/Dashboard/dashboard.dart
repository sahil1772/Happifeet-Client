import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/components/HappiFeetAppBar.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/screens/Dashboard/Graph%20Model/GraphData.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:happifeet_client_app/utils/ColorParser.dart';
import 'package:happifeet_client_app/utils/DeviceDimensions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  gotoDashboard(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (_) => DashboardWidget()));

  }

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

enum Filter_TYPE { WEEKLY, MONTHLY, YEARLY, ALL }

class _DashboardWidgetState extends State<DashboardWidget> {
  double graphSize = 0;
  int MIN = 10;
  int MAX = 100;

  Filter_TYPE type = Filter_TYPE.WEEKLY;
  List<dynamic> locations = [];
  List<dynamic> comments = [];
  Map<String, dynamic> parks = {};

  List<ColumnSeries> commentsGraphColumns = <ColumnSeries<GraphData, String>>[
    // Bind data source
  ];

  List<LineSeries> ratingGraphLine = <LineSeries<GraphData, String>>[];

  List<StackedColumnSeries> recommendationStackedColumns =
      <StackedColumnSeries<GraphData, String>>[];

  String? selectedParkId = "";

  @override
  void initState() {

    SharedPref.instance.getUserData();
    getParks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    graphSize = DeviceDimensions.getDeviceHeight(context) / 4;
    double HEADER_AREA = 3.5;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: HappiFeetAppBar(IsDashboard: true, isCitiyList: false)
            .getAppBar(context),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
                height: DeviceDimensions.getHeaderSize(context, HEADER_AREA),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    ColorParser().hexToColor("#34A846"),
                    ColorParser().hexToColor("#83C03D")
                  ],
                )),
                child: Container(
                  color: Colors.red,
                  margin: EdgeInsets.only(
                      top: HappiFeetAppBar(
                              IsDashboard: false, isCitiyList: false)
                          .getAppBar(context)
                          .preferredSize
                          .height,
                    bottom:DeviceDimensions.getBottomSheetHeight(context, HEADER_AREA)
                  ),
                  child: const Center(
                    child: Text(
                      "Dashboard",
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
            Positioned(
                right: 0,
                top: MediaQuery.of(context).size.height / 9.5,
                child: SvgPicture.asset(
                  "assets/images/manage/manageBG.svg",
                )),
            Container(
              height: DeviceDimensions.getBottomSheetHeight(context, HEADER_AREA),
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
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: parks.length > 0
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text("Select Location",
                                  style: TextStyle(
                                      color: Color(0xff383838), fontSize: 16)),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: DropdownMenu<String>(
                                width: MediaQuery.of(context).size.width - 32,
                                enableSearch: false,
                                inputDecorationTheme: InputDecorationTheme(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                requestFocusOnTap: false,
                                label: const Text('Select'),
                                initialSelection: selectedParkId,
                                onSelected: (String? park) {
                                  selectedParkId = park;
                                  log("Selected PARK => $park");
                                  setState(() {});
                                },
                                dropdownMenuEntries: [
                                  for (int i = 0; i < parks.keys.length; i++)
                                    DropdownMenuEntry<String>(
                                      value: parks.keys.elementAt(i),
                                      label: parks.values.elementAt(i),
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                      fit: FlexFit.loose,
                                      flex: 1,
                                      child: OutlinedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    type == Filter_TYPE.WEEKLY
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : Colors.transparent),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0))),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              type = Filter_TYPE.WEEKLY;
                                            });
                                          },
                                          child: Text(
                                            "Weekly",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color:
                                                    type == Filter_TYPE.WEEKLY
                                                        ? Colors.white
                                                        : Theme.of(context)
                                                            .primaryColor),
                                          ))),
                                  Flexible(
                                      fit: FlexFit.loose,
                                      flex: 1,
                                      child: OutlinedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    type == Filter_TYPE.MONTHLY
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : Colors.transparent),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0))),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              type = Filter_TYPE.MONTHLY;
                                            });
                                          },
                                          child: Text(
                                            "Monthly",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color:
                                                    type == Filter_TYPE.MONTHLY
                                                        ? Colors.white
                                                        : Theme.of(context)
                                                            .primaryColor),
                                          ))),
                                  Flexible(
                                      fit: FlexFit.loose,
                                      flex: 1,
                                      child: OutlinedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    type == Filter_TYPE.YEARLY
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : Colors.transparent),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0))),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              type = Filter_TYPE.YEARLY;
                                            });
                                          },
                                          child: Text(
                                            "Yearly",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color:
                                                    type == Filter_TYPE.YEARLY
                                                        ? Colors.white
                                                        : Theme.of(context)
                                                            .primaryColor),
                                          ))),
                                  Flexible(
                                      fit: FlexFit.loose,
                                      flex: 1,
                                      child: OutlinedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    type == Filter_TYPE.ALL
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : Colors.transparent),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0))),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              type = Filter_TYPE.ALL;
                                            });
                                          },
                                          child: Text(
                                            "All",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: type == Filter_TYPE.ALL
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                        .primaryColor),
                                          ))),
                                ],
                              ),
                            ),
                            FutureBuilder(
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                Widget toReturn;
                                switch (snapshot.connectionState) {
                                  case ConnectionState.active:
                                    toReturn = const Padding(
                                      padding: EdgeInsets.all(64.0),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                    break;
                                  case ConnectionState.waiting:
                                    toReturn = const Padding(
                                      padding: EdgeInsets.all(64.0),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );

                                    break;
                                  case ConnectionState.done:
                                    toReturn = Column(
                                      children: [
                                        getGraphs(),
                                        getReviews(),
                                      ],
                                    );
                                    break;
                                  case ConnectionState.none:
                                    toReturn = const Padding(
                                      padding: EdgeInsets.all(64.0),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                    break;
                                }
                                return toReturn;
                              },
                              future: getData(selectedParkId, type.name),
                            ),
                          ],
                        )
                      : const Center(
                          child: Padding(
                            padding: EdgeInsets.all(56.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                  // child: FutureBuilder(
                  //   future: getParks(),
                  //   builder: (context, snapshot) {
                  //     Widget toReturn = SizedBox();
                  //     switch(snapshot.connectionState){
                  //       case ConnectionState.done:
                  //         toReturn = Column(
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: [
                  //             const Padding(
                  //               padding: EdgeInsets.all(16.0),
                  //               child: Text("Select Location",
                  //                   style: TextStyle(
                  //                       color: Color(0xff383838), fontSize: 16)),
                  //             ),
                  //             Container(
                  //               margin: const EdgeInsets.symmetric(horizontal: 16),
                  //               child: DropdownMenu<String>(
                  //                 width: MediaQuery.of(context).size.width - 32,
                  //                 enableSearch: true,
                  //                 inputDecorationTheme: InputDecorationTheme(
                  //                     border: OutlineInputBorder(
                  //                         borderRadius: BorderRadius.circular(15))),
                  //                 requestFocusOnTap: true,
                  //                 label: const Text('Select'),
                  //                 initialSelection: "Select",
                  //                 onSelected: (String? park) {
                  //                   log("Selected PARK => $park");
                  //                   setState(() {});
                  //                 },
                  //                 dropdownMenuEntries: [
                  //                   for (int i = 0; i < parks.keys.length; i++)
                  //                     DropdownMenuEntry<String>(
                  //                       value: parks.keys.elementAt(i),
                  //                       label: parks.values.elementAt(i),
                  //                     ),
                  //                 ],
                  //               ),
                  //             ),
                  //             Container(
                  //               margin: const EdgeInsets.symmetric(vertical: 16),
                  //               child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                 children: [
                  //                   Flexible(
                  //                       fit: FlexFit.loose,
                  //                       flex: 1,
                  //                       child: OutlinedButton(
                  //                           style: ButtonStyle(
                  //                             backgroundColor:
                  //                             MaterialStateProperty.all(type ==
                  //                                 Filter_TYPE.WEEKLY
                  //                                 ? Theme.of(context).primaryColor
                  //                                 : Colors.transparent),
                  //                             shape: MaterialStateProperty.all(
                  //                                 RoundedRectangleBorder(
                  //                                     borderRadius:
                  //                                     BorderRadius.circular(10.0))),
                  //                           ),
                  //                           onPressed: () {
                  //                             setState(() {
                  //                               type = Filter_TYPE.WEEKLY;
                  //                             });
                  //                           },
                  //                           child: Text(
                  //                             "Weekly",
                  //                             style: TextStyle(
                  //                                 fontSize: 12,
                  //                                 color: type == Filter_TYPE.WEEKLY
                  //                                     ? Colors.white
                  //                                     : Theme.of(context).primaryColor),
                  //                           ))),
                  //                   Flexible(
                  //                       fit: FlexFit.loose,
                  //                       flex: 1,
                  //                       child: OutlinedButton(
                  //                           style: ButtonStyle(
                  //                             backgroundColor:
                  //                             MaterialStateProperty.all(type ==
                  //                                 Filter_TYPE.MONTHLY
                  //                                 ? Theme.of(context).primaryColor
                  //                                 : Colors.transparent),
                  //                             shape: MaterialStateProperty.all(
                  //                                 RoundedRectangleBorder(
                  //                                     borderRadius:
                  //                                     BorderRadius.circular(10.0))),
                  //                           ),
                  //                           onPressed: () {
                  //                             setState(() {
                  //                               type = Filter_TYPE.MONTHLY;
                  //                             });
                  //                           },
                  //                           child: Text(
                  //                             "Monthly",
                  //                             style: TextStyle(
                  //                                 fontSize: 12,
                  //                                 color: type == Filter_TYPE.MONTHLY
                  //                                     ? Colors.white
                  //                                     : Theme.of(context).primaryColor),
                  //                           ))),
                  //                   Flexible(
                  //                       fit: FlexFit.loose,
                  //                       flex: 1,
                  //                       child: OutlinedButton(
                  //                           style: ButtonStyle(
                  //                             backgroundColor:
                  //                             MaterialStateProperty.all(type ==
                  //                                 Filter_TYPE.YEARLY
                  //                                 ? Theme.of(context).primaryColor
                  //                                 : Colors.transparent),
                  //                             shape: MaterialStateProperty.all(
                  //                                 RoundedRectangleBorder(
                  //                                     borderRadius:
                  //                                     BorderRadius.circular(10.0))),
                  //                           ),
                  //                           onPressed: () {
                  //                             setState(() {
                  //                               type = Filter_TYPE.YEARLY;
                  //                             });
                  //                           },
                  //                           child: Text(
                  //                             "Yearly",
                  //                             style: TextStyle(
                  //                                 fontSize: 12,
                  //                                 color: type == Filter_TYPE.YEARLY
                  //                                     ? Colors.white
                  //                                     : Theme.of(context).primaryColor),
                  //                           ))),
                  //                   Flexible(
                  //                       fit: FlexFit.loose,
                  //                       flex: 1,
                  //                       child: OutlinedButton(
                  //                           style: ButtonStyle(
                  //                             backgroundColor:
                  //                             MaterialStateProperty.all(type ==
                  //                                 Filter_TYPE.ALL
                  //                                 ? Theme.of(context).primaryColor
                  //                                 : Colors.transparent),
                  //                             shape: MaterialStateProperty.all(
                  //                                 RoundedRectangleBorder(
                  //                                     borderRadius:
                  //                                     BorderRadius.circular(10.0))),
                  //                           ),
                  //                           onPressed: () {
                  //                             setState(() {
                  //                               type = Filter_TYPE.ALL;
                  //                             });
                  //                           },
                  //                           child: Text(
                  //                             "All",
                  //                             style: TextStyle(
                  //                                 fontSize: 12,
                  //                                 color: type == Filter_TYPE.ALL
                  //                                     ? Colors.white
                  //                                     : Theme.of(context).primaryColor),
                  //                           ))),
                  //                 ],
                  //               ),
                  //             ),
                  //             FutureBuilder(
                  //               builder: (BuildContext context,
                  //                   AsyncSnapshot<dynamic> snapshot) {
                  //                 Widget toReturn;
                  //                 switch (snapshot.connectionState) {
                  //                   case ConnectionState.active:
                  //                     toReturn = const Padding(
                  //                       padding: EdgeInsets.all(64.0),
                  //                       child:
                  //                       Center(child: CircularProgressIndicator()),
                  //                     );
                  //                     break;
                  //                   case ConnectionState.waiting:
                  //                     toReturn = const Padding(
                  //                       padding: EdgeInsets.all(64.0),
                  //                       child:
                  //                       Center(child: CircularProgressIndicator()),
                  //                     );
                  //
                  //                     break;
                  //                   case ConnectionState.done:
                  //                     toReturn = Column(
                  //                       children: [
                  //                         getGraphs(),
                  //                         getReviews(),
                  //                       ],
                  //                     );
                  //                     break;
                  //                   case ConnectionState.none:
                  //                     toReturn = const Padding(
                  //                       padding: EdgeInsets.all(64.0),
                  //                       child:
                  //                       Center(child: CircularProgressIndicator()),
                  //                     );
                  //                     break;
                  //                 }
                  //                 return toReturn;
                  //               },
                  //               future: getData(selectedParkId, type.name),
                  //             ),
                  //           ],
                  //         );
                  //         break;
                  //       case ConnectionState.waiting:
                  //         toReturn = Center(child: Padding(
                  //           padding: const EdgeInsets.all(56.0),
                  //           child: CircularProgressIndicator(),
                  //         ));
                  //         break;
                  //       case ConnectionState.none:
                  //         toReturn = Center(child: Padding(
                  //           padding: const EdgeInsets.all(56.0),
                  //           child: CircularProgressIndicator(),
                  //         ));
                  //         break;
                  //       case ConnectionState.active:
                  //         toReturn = Center(child: Padding(
                  //           padding: const EdgeInsets.all(56.0),
                  //           child: CircularProgressIndicator(),
                  //         ));
                  //         break;
                  //
                  //     }
                  //     return toReturn;
                  //
                  //   }
                  // )),
                ))
          ],
        ),
      ),
    );
  }

  getGraphs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Comments",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 18)),
        ),
        SizedBox(
          height: graphSize,
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              legend: const Legend(isVisible: false),
              tooltipBehavior: TooltipBehavior(enable: false),
              series: commentsGraphColumns),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Average Rating",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 18)),
        ),
        SizedBox(
          height: graphSize,
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              legend: const Legend(isVisible: false),
              tooltipBehavior: TooltipBehavior(enable: false),
              series: ratingGraphLine),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Recommendation",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 18)),
        ),
        SizedBox(
          height: graphSize,
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              legend: const Legend(
                  isVisible: true,
                  alignment: ChartAlignment.center,
                  position: LegendPosition.bottom),
              tooltipBehavior: TooltipBehavior(enable: false),
              series: recommendationStackedColumns),
        ),
      ],
    );
  }

  getReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Locations",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 18)),
        ),
        Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 6,
          margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
          child: Column(
            children: [
              for (int i = 0; i < locations.length; i++)
                Flex(
                  mainAxisSize: MainAxisSize.min,
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16.0),
                        child: Flex(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          direction: Axis.vertical,
                          children: [
                            Text(
                              locations[i]["park_name"],
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                locations[i]["address"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorParser().hexToColor("#757575")),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0x15000000))),
                        child: Flex(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          direction: Axis.vertical,
                          children: [
                            Text(
                              locations[i]["feedback_count"],
                              style: TextStyle(
                                  fontSize: 28,
                                  color: Theme.of(context).primaryColor),
                            ),
                            Text(
                              "Total Feedback",
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Theme.of(context).primaryColor),
              child: const Text(
                "View All",
                style: TextStyle(color: Colors.white),
              )),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 16.0, top: 16, right: 16, bottom: 10),
          child: Text("Latest Comments",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 18)),
        ),
        SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int commentIndex = 0;
                  commentIndex < comments.length;
                  commentIndex++)
                Container(
                  width: DeviceDimensions.getDeviceWidth(context),
                  child: Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    elevation: 6,
                    margin:
                        const EdgeInsets.only(bottom: 24, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comments[commentIndex]["description"],
                                style: const TextStyle(
                                    color: Color(0xff757575), fontSize: 12),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10),
                                child: RatingBar.builder(
                                  initialRating: double.parse(
                                      comments[commentIndex]["rating"]),
                                  minRating: double.parse(
                                      comments[commentIndex]["rating"]),
                                  maxRating: double.parse(
                                      comments[commentIndex]["rating"]),
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  ignoreGestures: true,
                                  tapOnlyMode: false,
                                  itemCount: 5,
                                  itemSize: 16,
                                  itemPadding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {},
                                ),
                              ),
                              Text(
                                "Will you recommend us ?",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: Text(
                                  "Maybe",
                                  style: TextStyle(
                                      color: Color(0xff757575), fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: const Color(0x15000000),
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Flexible(
                              fit: FlexFit.tight,
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "John Wick",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff757575)),
                                    ),
                                    Text(
                                      "Jan, 25, 2023",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff757575)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              flex: 1,
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Image.asset(
                                          "assets/images/comments/visible.svg",
                                          width: 20,
                                          height: 20,
                                          errorBuilder:
                                              (context, error, stackTrace) {


                                            return const SizedBox();
                                          },
                                        ),
                                      ),
                                      const Center(
                                        child: Text(
                                          "View",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff757575)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              flex: 2,
                              child: Container(
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 16),
                                  child: Center(
                                    child: Text(
                                      "Completed",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff757575)),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }

  void fetchComments(Map<String, dynamic> responseData) {
    Map<String, dynamic> commentData = responseData["commentsGraph"];

    List<GraphData> comments = [];

    commentData.forEach((key, value) {
      comments.add(GraphData(yCoordinateValue: value, xCoordinateName: key));
    });

    commentsGraphColumns.add(ColumnSeries<GraphData, String>(
      dataSource: comments,
      color: Colors.lightGreen,
      xValueMapper: (GraphData datum, _) {
        return datum.xCoordinateName.toString();
      },
      yValueMapper: (GraphData datum, _) {
        return int.parse(datum.yCoordinateValue);
      },
    ));
  }

  void fetchRatings(Map<String, dynamic> responseData) {
    Map<String, dynamic> ratingData = responseData["ratingGraph"];

    List<GraphData> ratings = [];

    ratingData.forEach((key, value) {
      ratings.add(GraphData(yCoordinateValue: value, xCoordinateName: key));
    });

    ratingGraphLine.add(LineSeries<GraphData, String>(
      dataSource: ratings,
      color: const Color(0xffC99700),
      markerSettings: const MarkerSettings(isVisible: true),
      dataLabelSettings: const DataLabelSettings(
        isVisible: false,
      ),
      xValueMapper: (GraphData datum, _) {
        return datum.xCoordinateName.toString();
      },
      yValueMapper: (GraphData datum, _) {
        return datum.yCoordinateValue;
      },
    ));
  }

  void fetchRecommendation(Map<String, dynamic> responseData) {
    Map<String, dynamic> recommendationData = responseData["recommendGraph"];

    List<GraphData> happyRecommendations = [];
    List<GraphData> notreallyRecommendations = [];
    List<GraphData> maybeRecommendations = [];

    recommendationData.forEach((key, value) {
      happyRecommendations.add(
          GraphData(xCoordinateName: key, yCoordinateValue: value["happily"]));
      notreallyRecommendations.add(GraphData(
          xCoordinateName: key, yCoordinateValue: value["not_really"]));
      maybeRecommendations.add(
          GraphData(xCoordinateName: key, yCoordinateValue: value["maybe"]));
    });
    recommendationStackedColumns.add(StackedColumnSeries<GraphData, String>(
      legendIconType: LegendIconType.rectangle,
      legendItemText: "Happily",
      markerSettings: const MarkerSettings(),
      dataSource: happyRecommendations,
      color: Colors.green,
      xValueMapper: (GraphData datum, _) {
        return datum.xCoordinateName.toString();
      },
      yValueMapper: (GraphData datum, _) {
        return int.parse(datum.yCoordinateValue);
      },
    ));

    recommendationStackedColumns.add(StackedColumnSeries<GraphData, String>(
      dataSource: notreallyRecommendations,
      legendIconType: LegendIconType.rectangle,
      legendItemText: "Unhappy",
      color: Colors.deepOrangeAccent,
      xValueMapper: (GraphData datum, _) {
        return datum.xCoordinateName.toString();
      },
      yValueMapper: (GraphData datum, _) {
        return int.parse(datum.yCoordinateValue);
      },
    ));
    recommendationStackedColumns.add(StackedColumnSeries<GraphData, String>(
      dataSource: maybeRecommendations,
      legendIconType: LegendIconType.rectangle,
      legendItemText: "Maybe",
      color: Colors.orangeAccent,
      xValueMapper: (GraphData datum, _) {
        return datum.xCoordinateName.toString();
      },
      yValueMapper: (GraphData datum, _) {
        return int.parse(datum.yCoordinateValue);
      },
    ));
  }

  void fetchLocationData(Map<String, dynamic> responseData) {
    log("RUN TIME TYPE OF location_feedback_count => ${responseData["location_feedback_count"].runtimeType}");

    locations = responseData["location_feedback_count"];

    // List<LocationFeedback> locationFeedback = List<LocationFeedback>.from(json.decode(json.encode(responseData["location_feedback_count"]).toString()))
    //     .map((model) => LocationFeedback.fromJson(model)));
  }

  void fetchCommentsData(Map<String, dynamic> responseData) {
    log("RUN TIME TYPE OF feedback_list => ${responseData["feedback_list"].runtimeType}");

    comments = responseData["feedback_list"];
  }

  Future<Map<String, dynamic>?> getData(
      String? parkId, String? filterBy) async {
    if (commentsGraphColumns != null) {
      //Clearing Comments Data
      commentsGraphColumns.clear();
    }
    if (ratingGraphLine != null) {
      //Clearing Ratings Data
      ratingGraphLine.clear();
    }

    if (recommendationStackedColumns != null) {
      //Clearing Recommendation Data
      recommendationStackedColumns.clear();
    }

    Response? dashboardResponse = await ApiFactory()
        .getDashboardService()
        .getParkAnalytics(parkId, filterBy!.toLowerCase());

    Map<String, dynamic> responseData = json.decode(dashboardResponse!.data!);

    fetchComments(responseData);
    fetchRatings(responseData);
    fetchRecommendation(responseData);

    fetchLocationData(responseData);
    fetchCommentsData(responseData);

    return responseData;
  }

  Future<void> getParks() async {
    Response? dashboardResponse =
        await ApiFactory().getDashboardService().getParks("302");

    Map<String, dynamic> responseData = json.decode(dashboardResponse!.data!);

    parks = responseData!["location_list"];
    selectedParkId = parks.keys.first;

    setState(() {});
  }
}
