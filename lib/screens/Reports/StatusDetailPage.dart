import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/components/AddComment.dart';
import 'package:happifeet_client_app/model/AssignedUsers/AssignedUserData.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/network/services/ApiService.dart';
import 'package:happifeet_client_app/storage/runtime_storage.dart';
import 'package:happifeet_client_app/utils/ColorParser.dart';

import '../../model/FeedbackStatus/FeedbackStatusDetails.dart';
import '../../resources/resources.dart';

class StatusDetailPage extends StatefulWidget {
  String? report_id;

    StatusDetailPage({Key? key, this.report_id});

  gotoStatusFilterPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => StatusDetailPage()));
  }

  @override
  State<StatusDetailPage> createState() => _StatusDetailPageState();
}

enum Status { Pending, Resolved }

class _StatusDetailPageState extends State<StatusDetailPage> {
  List<FeedbackStatusDetails>? getStatusDetails;
  Future<List<FeedbackStatusDetails>>? apiResponse;
  List<AssignedUserData>? userListing = [];

  @override
  void initState() {
    // TODO: implement initState
    apiResponse = getFeedbackStatusDetails();
    super.initState();
  }

  Future<List<FeedbackStatusDetails>>? getFeedbackStatusDetails() async {
    var response = ApiFactory()
        .getFeedbackStatusService()
        .getFeedbackStatusDetails("feedback_view_report", widget.report_id!);
    log("DATA IN STATUS DETAILS ${getStatusDetails}");
    getStatusDetails = await response;

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorParser().hexToColor(
                                RuntimeStorage
                                    .instance.clientTheme!.button_background!),
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                                "assets/images/comments/close.svg"),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Close",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 35,
                ),

                /** QUESTIONS **/

                FutureBuilder<List<FeedbackStatusDetails>?>(
                  future: apiResponse,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<FeedbackStatusDetails>?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 15,
                                mainAxisExtent: 80),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const ScrollPhysics(),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Location Name",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              Text(snapshot.data!.first.park_name!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Resources.colors.hfText))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Share Anonymously",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              Text(snapshot.data!.first.anonymous_user!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Resources.colors.hfText))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("User Name",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              Text(snapshot.data!.first.user_name!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Resources.colors.hfText))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Email Address",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              Text(snapshot.data!.first.email_address!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Resources.colors.hfText))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Message",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              Text("Maybe",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Resources.colors.hfText))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Send Updates via Email",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              Text(snapshot.data!.first.send_updates!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Resources.colors.hfText))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Rating",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              Text(snapshot.data!.first.rating!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Resources.colors.hfText))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Recommend",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              Text(snapshot.data!.first.recommend!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Resources.colors.hfText))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("How safe do you feel hhhgfgh",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              Text(snapshot.data!.first.how_safe_feel!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Resources.colors.hfText))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Zip code",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              Text(snapshot.data!.first.zip_code_live!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Resources.colors.hfText))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Assigned By",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              Text(
                                  snapshot.data!.first.comment!.isNotEmpty
                                      ? snapshot
                                          .data!.first.comment!.first.assign_by!
                                      : "-",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Resources.colors.hfText))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Assigned To",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              Text(
                                  snapshot.data!.first.comment!.isNotEmpty
                                      ? snapshot
                                          .data!.first.comment!.first.assign_to!
                                      : "-",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Resources.colors.hfText))
                            ],
                          ),
                        ],
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return const Text("Something Went Wrong");
                    }
                  },
                ),

                /** COMMENTS **/
                const SizedBox(
                  height: 24,
                ),

                FutureBuilder<List<FeedbackStatusDetails>>(
                  future: apiResponse,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      print(
                          "ADFHSAGbsabhicjbsahc ${snapshot.data!.first.toJson()}");

                      if (snapshot.data!.first.comment!.length > 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Comments",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            const SizedBox(
                              height: 8,
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.first.comment!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    elevation: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GridView.count(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          crossAxisCount: 2,
                                          padding: EdgeInsets.zero,
                                          crossAxisSpacing: 0,
                                          childAspectRatio: 6 / 2,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text("Status",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black)),
                                                Text(
                                                  snapshot.data!.first
                                                      .comment![index].status!,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                const Text("Comment",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black)),
                                                Text(
                                                    snapshot
                                                        .data!
                                                        .first
                                                        .comment![index]
                                                        .comment!,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text("Added Date",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black)),
                                                Text(
                                                    snapshot
                                                        .data!
                                                        .first
                                                        .comment![index]
                                                        .added_date!,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                            snapshot.data!.first.comment![index]
                                                    .images_uploaded!.isNotEmpty
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      const Text(
                                                          "Uploaded File",
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .black)),
                                                      InkWell(
                                                        onTap: () {
                                                          showAttachment(
                                                              context: context,
                                                              image: snapshot
                                                                  .data!
                                                                  .first
                                                                  .comment![
                                                                      index]
                                                                  .images_uploaded!);
                                                        },
                                                        child: Text(
                                                            "View Document",
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ],
                                                  )
                                                : SizedBox()
                                          ]),
                                    ),
                                  );
                                })
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    } else {
                      return const SizedBox();
                    }
                  },
                ),

                // GridView.builder(
                //     gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //     mainAxisSpacing: 0,
                //     // crossAxisSpacing: 15,
                //     // mainAxisExtent: 80
                //     ),
                //   shrinkWrap: true,
                //   physics: ScrollPhysics(),
                //   itemBuilder: (BuildContext context, int index) {
                //       return Column(
                //         children: [
                //           Text(),
                //           Text()
                //         ],
                //       );
                //   },
                //
                // ),

                /** SELECT LANG **/
                // const SizedBox(
                //   height: 24,
                // ),
                // const Text("Select Language",
                //     style: TextStyle(
                //         fontSize: 18,
                //         fontWeight: FontWeight.w500,
                //         color: Colors.black)),
                // const SizedBox(
                //   height: 8,
                // ),
                // Row(
                //   children: [
                //     OutlinedButton(
                //       onPressed: () {
                //         setState(() {
                //           isSelected = !isSelected;
                //         });
                //       },
                //       style: OutlinedButton.styleFrom(
                //         side: BorderSide(
                //           color: isSelected
                //               ? ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.button_background!)
                //               : Colors.grey,
                //         ),
                //       ),
                //       child: Text(
                //         "English",
                //         style: TextStyle(
                //             color: isSelected
                //                 ? ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.button_background!)
                //                 : Colors.grey),
                //       ),
                //     ),
                //     const SizedBox(
                //       width: 20,
                //     ),
                //     OutlinedButton(
                //       onPressed: () {
                //         setState(() {
                //           isSelected = !isSelected;
                //         });
                //       },
                //       style: OutlinedButton.styleFrom(
                //         side: BorderSide(
                //           color: isSelected
                //               ? Colors.grey
                //               : ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.button_background!),
                //         ),
                //       ),
                //       child: Text(
                //         "Español",
                //         style: TextStyle(
                //             color: isSelected
                //                 ? Colors.grey
                //                 : ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.button_background!)),
                //       ),
                //     )
                //   ],
                // ),

                /** COMMENTS **/

                FutureBuilder<List<FeedbackStatusDetails>>(
                    future: apiResponse,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return AddComment(
                          reportId: widget.report_id,
                          dataCallback: () {},
                          onFailure: () {},
                          onSuccess: () {
                            setState(() {
                              apiResponse = getFeedbackStatusDetails();
                            });
                          },
                          assignedTo: snapshot.data!.first.assign_to,
                        );
                      } else {
                        return SizedBox();
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showAttachment(
      {required BuildContext context, required List<String> image}) {
    showDialog(
      context: context,
      builder: (context) {
        return GridView.builder(
          padding: EdgeInsets.zero,
          itemCount: image.length,
          shrinkWrap: true,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Image.network(images_url+image[index]);
          },
        );
      },
    );
  }
}
