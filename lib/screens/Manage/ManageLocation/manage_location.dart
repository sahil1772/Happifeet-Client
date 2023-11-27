import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happifeet_client_app/components/LocationCard.dart';
import 'package:happifeet_client_app/screens/Manage/ManageLocation/AddLocation.dart';

import '../../../components/HappiFeetAppBar.dart';
import '../../../storage/shared_preferences.dart';
import '../../../utils/ColorParser.dart';

class ManageLocationWidget extends StatefulWidget{


  gotoManageLocation(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (_) =>  ManageLocationWidget()));
  }

  @override
  State<ManageLocationWidget> createState() => _ManageLocationWidgetState();

}

class _ManageLocationWidgetState extends State<ManageLocationWidget>{
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    extendBodyBehindAppBar: true,
    appBar: HappiFeetAppBar(IsDashboard: false, isCitiyList: false)
        .getAppBar(context),
    body: Stack(
      children: [
        Container(
            decoration:  BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [ ColorParser().hexToColor("#34A846"),ColorParser().hexToColor("#83C03D")],
                )),
            child: Column(children: [
              // SizedBox(height: 105),
              Padding(
                padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(

                      "Manage Location",
                      // "Select Location".tr(),
                      // "Select Location".language(context),
                      // widget.selectedLanguage == "1" ? 'Select Location'.language(context) : 'Select Location',
                      style: TextStyle(

                          color:  Colors.white,
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
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration:  BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    color:  Colors.white),
                // color: Colors.white,
                child: SingleChildScrollView(

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /** Search bar **/
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 26),
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
                                    style: TextStyle(fontSize: 16),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.search),
                                      prefixIconColor: ColorParser().hexToColor("#1A7C52"),
                                      labelText: 'Search',
                                      // labelText: widget.selectedLanguage == "1"
                                      //     ? "Search".language(context)
                                      //     : "Search",
                                      labelStyle: TextStyle(color: ColorParser().hexToColor("#9E9E9E")),

                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 1,

                                          ),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color:  Colors.grey,),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                    )),
                              ),
                            ),

                          ],
                        ),
                      ),
                      /**   listview builder     **/

                      /**  Location Listing **/

                      Flexible(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,

                          physics: ScrollPhysics(),
                          itemCount: 10,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return LocationCard();
                          }, separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 8,); },
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
    bottomSheet: Container(
      height: 50,
      color: ColorParser().hexToColor("#1A7C52"),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(

              onPressed: () {
                AddLocation().gotoAddLocation(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: ColorParser().hexToColor("#1A7C52"),elevation: 0),
              child: Text("Add Location",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),

            ),
          ),
        ],
      ),
    ),
  );
  }
}