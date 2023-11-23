import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/HappiFeetAppBar.dart';

class ManageWidget extends StatefulWidget{
  @override
  State<ManageWidget> createState() => _ManageWidgetState();

}

class _ManageWidgetState extends State<ManageWidget>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: HappiFeetAppBar(IsDashboard: true,isCitiyList: true)
          .getAppBar(context),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green, Colors.white],
                )),
            child: Padding(
              padding: const EdgeInsets.only(left: 20,top: 140),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Manage',
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
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           children: [
                             Container(
                               decoration: BoxDecoration(border: Border.all(color: Colors.black12,),borderRadius: BorderRadius.all(Radius.circular(14))),
                               width: 180,
                               height: 160,
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   SvgPicture.asset("assets/images/manage/location.svg"),
                                   SizedBox(height: 5,),
                                   Text("Manage \nLocation",textAlign: TextAlign.center),
                                 ],
                               ),
                             ),
                             Container(
                               decoration: BoxDecoration(border: Border.all(color: Colors.black12),borderRadius: BorderRadius.all(Radius.circular(14),)),
                               width: 180,
                               height: 160,
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   SvgPicture.asset("assets/images/manage/users.svg"),
                                   SizedBox(height: 5,),
                                   Text("Manage \nUsers",textAlign: TextAlign.center),
                                 ],
                               ),
                             ),
                           ],
                         ),
                          /** Second Row **/
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.black12,),borderRadius: BorderRadius.all(Radius.circular(14))),
                                width: 180,
                                height: 160,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset("assets/images/manage/location.svg"),
                                    SizedBox(height: 5,),
                                    Text("Manage \nAnnouncement",textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.black12),borderRadius: BorderRadius.all(Radius.circular(14),)),
                                width: 180,
                                height: 160,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset("assets/images/manage/users.svg"),
                                    SizedBox(height: 5,),
                                    Text("Manage \nSMTP Details",textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ],
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