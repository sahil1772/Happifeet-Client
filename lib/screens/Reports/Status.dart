import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/HappiFeetAppBar.dart';
import '../../components/StatusCard.dart';
import '../../resources/resources.dart';
import '../../utils/ColorParser.dart';
import 'StatusFilterpage.dart';

class StatusWidget extends StatefulWidget{



  gotoStatusPage(BuildContext context){

    Navigator.push(context, MaterialPageRoute(builder: (_) => StatusWidget() ));
  }


  @override
  State<StatusWidget> createState() => _StatusWidgetState();
  
}

class _StatusWidgetState extends State<StatusWidget>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: HappiFeetAppBar(IsDashboard: false, isCitiyList: false)
          .getAppBar(context),
      body:
      // locationDetails.isEmpty ? CircularProgressIndicator() :
      Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ColorParser().hexToColor("#34A846"),
                      ColorParser().hexToColor("#83C03D")
                    ],
                  )),
              child: Column(children: [
                // SizedBox(height: 105),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery
                      .of(context)
                      .size
                      .height / 8),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(

                        "Status",
                        // "Select Location".tr(),
                        // "Select Location".language(context),
                        // widget.selectedLanguage == "1" ? 'Select Location'.language(context) : 'Select Location',
                        style: TextStyle(

                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ])),
          DraggableScrollableSheet(

              initialChildSize: 0.8,
              minChildSize: 0.8,
              maxChildSize: 0.8,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
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

                          padding: const EdgeInsets.only(left: 8,top: 20,right: 8,bottom: 20),
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
                                            onTap: () {

                                              Navigator.of(context).push(_createRoute());
                                            },
                                            child: SvgPicture.asset(
                                                "assets/images/comments/filter.svg")),
                                        prefixIconConstraints: BoxConstraints(
                                            minHeight: 30, minWidth: 60),
                                        prefixIconColor: ColorParser()
                                            .hexToColor("#1A7C52"),
                                        labelText: ' Filters',
                                        // labelText: widget.selectedLanguage == "1"
                                        //     ? "Search".language(context)
                                        //     : "Search",
                                        labelStyle: TextStyle(
                                            color: ColorParser().hexToColor(
                                                "#9E9E9E")),

                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                              width: 1,

                                            ),
                                            borderRadius: BorderRadius.circular(
                                                10)
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: Colors.grey,),
                                            borderRadius: BorderRadius.circular(
                                                10)
                                        ),
                                      )),
                                ),
                              ),

                            ],
                          ),
                        ),

                        Padding(
                          // padding: const EdgeInsets.symmetric(horizontal: 6),
                          padding: const EdgeInsets.only(left: 6,right: 6,bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 95,
                                width: 115,
                                decoration: BoxDecoration(color: ColorParser().hexToColor("#FC8F01"),borderRadius: BorderRadius.circular(10),),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("10",style: TextStyle(fontSize: 28,fontWeight: FontWeight.w500,color: Colors.white),),
                                    Text("Total",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.white),),
                                    Text("Feedback",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.white)),
                                  ],
                                ),
                              ),
                              Container(
                                height: 95,
                                width: 115,
                                decoration: BoxDecoration(color: ColorParser().hexToColor("#1A7B51"),borderRadius: BorderRadius.circular(10),),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    Text("2",style: TextStyle(fontSize: 28,fontWeight: FontWeight.w500,color: Colors.white),),
                                    Text("Total",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.white),),
                                    Text("Resolved",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.white),),
                                  ],
                                ),
                              ),
                              Container(
                                height: 95,
                                width: 115,
                                decoration: BoxDecoration(color: ColorParser().hexToColor("#CEB02E"),borderRadius: BorderRadius.circular(10),),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("8",style: TextStyle(fontSize: 28,fontWeight: FontWeight.w500,color: Colors.white),),
                                    Text("Total",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.white),),
                                    Text("Pending",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.white),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8,right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(
                                  onPressed: (){},
                                  // style: OutlinedButton.styleFrom(
                                  //   // shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                                  //   side: BorderSide(
                                  //     color:  Resources.colors.buttonColorDark,
                                  //   ),
                                  // ),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),

                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset("assets/images/status/pdf.svg"),
                                      SizedBox(width: 10,),
                                      Text("Export to PDF"),
                                    ],
                                  )),
                              OutlinedButton(
                                  onPressed: (){},
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),

                                  ),

                                  child: Row(
                                    children: [
                                      SvgPicture.asset("assets/images/status/excel.svg"),
                                      SizedBox(width: 10,),
                                      Text("Export to Excel"),
                                    ],
                                  )),
                            ],
                          ),
                        ),

                        /**   listview builder     **/

                        /**  Comments card Listing **/

                        Flexible(
                          child: ListView.separated(
                            padding: EdgeInsets.zero,

                            physics: const ScrollPhysics(),
                            itemCount: 10,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return StatusCard();
                            },
                            separatorBuilder: (BuildContext context,
                                int index) {
                              return SizedBox(height: 8,);
                            },
                          ),
                        ),
                        SizedBox(height: 50,),
                      ],
                    ),
                  ),
                );
              })
        ],
      ),

    );
  }

  Route _createRoute() {
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