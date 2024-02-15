import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/model/Theme/ClientTheme.dart';
import 'package:happifeet_client_app/screens/Reports/Comments.dart';
import 'package:happifeet_client_app/screens/Reports/Status.dart';
import 'package:happifeet_client_app/storage/runtime_storage.dart';

import '../../components/HappiFeetAppBar.dart';
import '../../resources/resources.dart';
import '../../storage/shared_preferences.dart';
import '../../utils/ColorParser.dart';
import '../../utils/DeviceDimensions.dart';

class ReportsWidget extends StatefulWidget {
  ClientTheme? clientTheme;

  ReportsWidget({super.key, this.clientTheme});

  @override
  State<ReportsWidget> createState() => _ReportsWidgetState();
}

class _ReportsWidgetState extends State<ReportsWidget> {
  ClientTheme? theme;

  @override
  void initState() {
    // TODO: implement initState
    SharedPref.instance.getCityTheme().then((value) {
      log("THEME IN REPORTS PAGE ${value}");
      theme = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double HEADER_AREA = 3.5;
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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
                          "Reports",
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
                        /** First Row **/
                        GridView(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 0,
                            crossAxisSpacing: 20,
                          ),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          children: [
                            InkWell(
                              onTap: () {
                                CommentsWidget().gotoCommentsWidget(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black12,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(14))),
                                width: 180,
                                height: 160,
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
                                          "assets/images/reports/comments.svg",
                                          colorFilter: ColorFilter.mode(
                                              Colors.white, BlendMode.srcIn),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("Comments",
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
                                StatusWidget().gotoStatusPage(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black12),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(14),
                                    )),
                                width: 180,
                                height: 160,
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
                                          "assets/images/reports/status.svg",
                                          colorFilter: ColorFilter.mode(
                                              Colors.white, BlendMode.srcIn),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("Status",
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
                        ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     InkWell(
                        //       onTap : (){
                        //         CommentsWidget().gotoCommentsWidget(context);
                        //       },
                        //       child: Container(
                        //         decoration: BoxDecoration(border: Border.all(color: Colors.black12,),borderRadius: const BorderRadius.all(Radius.circular(14))),
                        //         width: 180,
                        //         height: 160,
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             SvgPicture.asset("assets/images/reports/comments.svg"),
                        //             const SizedBox(height: 5,),
                        //              Text("Comments",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Resources.colors.hfText),textAlign: TextAlign.center),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //     InkWell(
                        //       onTap: (){
                        //         StatusWidget().gotoStatusPage(context);
                        //       },
                        //       child: Container(
                        //         decoration: BoxDecoration(border: Border.all(color: Colors.black12),borderRadius: const BorderRadius.all(Radius.circular(14),)),
                        //         width: 180,
                        //         height: 160,
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             SvgPicture.asset("assets/images/reports/status.svg"),
                        //             const SizedBox(height: 5,),
                        //              Text("Status",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Resources.colors.hfText),textAlign: TextAlign.center),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        /** Second Row **/
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
