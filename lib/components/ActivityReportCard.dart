import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../model/ActivityReport/ActivityReportData.dart';
import '../storage/runtime_storage.dart';
import '../utils/ColorParser.dart';

class ActivityReportCard extends StatefulWidget {
  ActivityReportData? activityReportData;

  ActivityReportCard({Key? key, this.activityReportData});

  @override
  State<ActivityReportCard> createState() => _ActivityReportCardState();
}

class _ActivityReportCardState extends State<ActivityReportCard> {
  String? activityDate;
  DateTime? tempDate;

  @override
  void initState() {
    // TODO: implement initState
    log("DATA IN ACTIVITY REPORT CARD${widget.activityReportData!.toJson()}");
    tempDate =
        DateFormat("yyyy-MM-dd").parse(widget.activityReportData!.add_date!);
    activityDate = DateFormat("dd-MMM-yyyy").format(tempDate!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        // padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
        padding: EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 0),
        // margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2, color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(10),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.activityReportData!.park_name!,
                style: TextStyle(fontSize: 18)),
            SizedBox(
              height: 20,
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/activityReport/date.svg",
                          colorFilter:
                              ColorFilter.mode(Colors.green, BlendMode.srcIn),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Date",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/activityReport/photoGallery.svg",
                          colorFilter:
                              ColorFilter.mode(Colors.green, BlendMode.srcIn),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Photo Gallery",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/activityReport/feedback.svg",
                          colorFilter:
                              ColorFilter.mode(Colors.green, BlendMode.srcIn),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Feedback",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/activityReport/detail.svg",
                          colorFilter:
                              ColorFilter.mode(Colors.green, BlendMode.srcIn),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Detail",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/activityReport/reservation.svg",
                          colorFilter:
                              ColorFilter.mode(Colors.green, BlendMode.srcIn),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Reservation",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Row(
                    //   children: [
                    //     SvgPicture.asset(
                    //       "assets/images/activityReport/detail.svg",
                    //       colorFilter:
                    //           ColorFilter.mode(Colors.green, BlendMode.srcIn),
                    //     ),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Text("Know More",
                    //         style: TextStyle(
                    //             fontSize: 14, fontWeight: FontWeight.w600)),
                    //   ],
                    // ),
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(activityDate!,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        widget.activityReportData!.photo_gallary == "0" ? "No" : "Yes",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(widget.activityReportData!.feedback! == "0" ? "No" : "Yes",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(widget.activityReportData!.detail! == "0" ? "No" : "Yes",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(widget.activityReportData!.reservation! == "0" ? "No" : "Yes",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Text(widget.activityReportData!.know_more! == "0" ? "No" : "Yes",
                    //     style: TextStyle(
                    //         fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
            // ListView.builder(
            //   padding: EdgeInsets.zero,
            //   itemCount: 5,
            //   shrinkWrap: true,
            //     itemBuilder: (BuildContext context, index){
            //       return Row(
            //         children: [
            //           SvgPicture.asset("assets/images/status/excel.svg",colorFilter: ColorFilter.mode(Colors.green, BlendMode.srcIn),),
            //           Text("Date"),
            //           Text("jhjhjhjhjhjhjhjh"),
            //         ]
            //         ,
            //       );
            //     })
          ],
        ),
      ),
    );
  }
}
