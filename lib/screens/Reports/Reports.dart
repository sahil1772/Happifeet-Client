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

class ReportsWidget extends StatefulWidget{
  ClientTheme?  clientTheme;
   ReportsWidget({super.key,this.clientTheme});

  @override
  State<ReportsWidget> createState() => _ReportsWidgetState();

}

class _ReportsWidgetState extends State<ReportsWidget>{
  ClientTheme? theme;
  @override
  void initState() {
    // TODO: implement initState
    SharedPref.instance.getCityTheme().then((value) {
      log("THEME IN REPORTS PAGE ${value}");
      theme = value;
      } );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: HappiFeetAppBar(IsDashboard: true,isCitiyList: false)
          .getAppBar(context),
      body: Stack(
        children: [
          Container(
            decoration:  BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                    ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!)
                  ],
                )),
            child: const Padding(
              padding: EdgeInsets.only(left: 20,top: 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Reports',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600,color: Colors.white),
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ),
          Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height/9.5,
              child: SvgPicture.asset("assets/images/manage/manageBG.svg",)),
          DraggableScrollableSheet(
              initialChildSize: 0.67,
              minChildSize: 0.67,
              maxChildSize: 0.67,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      color: Colors.white),
                  // color: Colors.white,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 22),
                      child: Column(
                        children: [
                          /** First Row **/
                          GridView(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 20,

                            ),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            children: [
                              InkWell(
                                      onTap : (){
                                        CommentsWidget().gotoCommentsWidget(context);
                                      },
                                child: Container(
                                  decoration: BoxDecoration(border: Border.all(color: Colors.black12,),borderRadius: const BorderRadius.all(Radius.circular(14))),
                                  width: 180,
                                  height: 160,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset("assets/images/reports/comments.svg"),
                                      const SizedBox(height: 5,),
                                      Text("Comments",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Resources.colors.hfText),textAlign: TextAlign.center),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                      onTap: (){
                                        StatusWidget().gotoStatusPage(context);
                                      },
                                child: Container(
                                  decoration: BoxDecoration(border: Border.all(color: Colors.black12),borderRadius: const BorderRadius.all(Radius.circular(14),)),
                                  width: 180,
                                  height: 160,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset("assets/images/reports/status.svg"),
                                      const SizedBox(height: 5,),
                                      Text("Status",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Resources.colors.hfText),textAlign: TextAlign.center),
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
                );
              })

        ],
      ),
    );
  }
}