import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/screens/Manage/ManageTrails/AddTrail.dart';

import '../model/Trails/TrailListingData.dart';
import '../network/ApiFactory.dart';
import '../storage/runtime_storage.dart';
import '../utils/ColorParser.dart';

class TrailListingCard extends StatefulWidget {
  TrailListingData? trailList;

  Function? callback;

  TrailListingCard({Key? key, this.trailList, this.callback});

  @override
  State<TrailListingCard> createState() => _TrailListingCardState();
}

class _TrailListingCardState extends State<TrailListingCard> {
  bool isEdit = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
      padding: const EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 0),
      // margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(
        //   color: Colors.black,
        // ),
        boxShadow: const [
          BoxShadow(blurRadius: 3, color: Colors.black12, spreadRadius: 2),
        ],
        borderRadius: BorderRadius.circular(10),
      ),

      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 170,
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.trailList!.trail_name!,
                          // overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5),
                        ),
                        // Text(
                        //   'Working Team',
                        //   // overflow: TextOverflow.ellipsis,
                        //   maxLines:1,
                        //   style: TextStyle(
                        //       color:   ColorParser().hexToColor("#757575"),
                        //       fontSize: 14,
                        //       fontWeight: FontWeight.w500,
                        //       letterSpacing: 0.5),
                        // ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                  "assets/images/trails/clock.svg"),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                widget.trailList!.opening_time!,
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: TextStyle(color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                  "assets/images/trails/clock.svg"),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                widget.trailList!.opening_time2!,
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: TextStyle(color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.0),
                          child: Row(
                            children: [
                              Text(
                                "Distance : ",
                                style: TextStyle(
                                  color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!),
                                ),
                              ),
                              Text(
                                widget.trailList!.distance!,
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: TextStyle(color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),
                              ),
                              Text(
                                " Miles",
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: TextStyle(color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(width: 10),
                  const SizedBox(
                    width: 35,
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              width: 55,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Colors.grey.shade200,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Divider(color: Colors.grey.shade200),
                  const SizedBox(
                    height: 8,
                  ),
                  InkWell(
                      onTap: () {
                        AddTrail.goToAddTrail(context, true, widget.trailList!.trail_id!, () {
                          widget.callback!();
                        });
                      },
                      child: SvgPicture.asset(
                          "assets/images/location/editing.svg")),
                  const SizedBox(
                    height: 8,
                  ),
                  Divider(color: Colors.grey.shade200),
                  const SizedBox(
                    height: 8,
                  ),
                  InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Delete Trail"),
                                content: Text(
                                    "Are you sure you want to delete this trail?"),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        var response = await ApiFactory()
                                            .getTrailService()
                                            .deleteTrail(
                                                widget.trailList!.trail_id!);
                                        if (response.status == "1") {
                                          log("Trail Deleted Successfully");
                                          widget.callback!();
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Trail Deleted Successfully")));
                                        } else {
                                          log("Error in client user delete");
                                        }
                                      },
                                      child: Text("Yes")),
                                  TextButton(
                                      onPressed: () => Navigator.of(context,
                                              rootNavigator: true)
                                          .pop(),
                                      child: Text("No")),
                                ],
                              );
                            });
                      },
                      child: SvgPicture.asset(
                          "assets/images/location/delete.svg")),
                  const SizedBox(
                    height: 8,
                  ),
                  Divider(color: Colors.grey.shade200),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
