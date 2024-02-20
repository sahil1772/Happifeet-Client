import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:happifeet_client_app/components/LocationCard.dart';
import 'package:happifeet_client_app/screens/Manage/ManageLocation/AddLocation.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../components/HappiFeetAppBar.dart';
import '../../../model/Location/LocationData.dart';
import '../../../model/Theme/ClientTheme.dart';
import '../../../network/ApiFactory.dart';
import '../../../storage/runtime_storage.dart';
import '../../../utils/ColorParser.dart';
import '../../../utils/DeviceDimensions.dart';

class LocationListing extends StatefulWidget {
  PersistentTabController? controller;

  LocationListing({Key? key,this.controller});
  gotoManageLocation(BuildContext context,PersistentTabController? controller) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => LocationListing(controller: controller,)));
  }

  @override
  State<LocationListing> createState() => _ManageLocationWidgetState();
}

class _ManageLocationWidgetState extends State<LocationListing> {
  List<LocationData> locationDetails = [];
  List<LocationData> locationDetailsTemp = [];
  ClientTheme? theme;

  @override
  void initState() {
    // TODO: implement initState
    SharedPref.instance.getCityTheme().then((value) {
      theme = value;
      getLocationDetails();} );


    super.initState();
  }

  Future<void> getLocationDetails() async {
    var response = await ApiFactory()
        .getLocationService()
        .getLocationListData("list_location");

    // var response = await ApiFactory().getLocationService().submitLocationData(data)
    // log("response inside manage location page ${response}");
    // log("response inside manage location page ${response}");
    locationDetails = response!;
    locationDetailsTemp = response;
    log("DATAAAA in locationDetails ${locationDetails}");
    setState(() {});
    log("LENGTHHHHHH${locationDetails.length}");

    setState(() {});
  }

  filterSearchResults(String keyword) async {
    log("search keyword ${keyword}");

    setState(() {
      if (keyword.isEmpty) {
        locationDetails = locationDetailsTemp;
      } else {
        locationDetails = locationDetailsTemp.where((element) {
          return (element as LocationData)
              .park_name!
              .toLowerCase()
              .toString()
              .contains(keyword.toLowerCase());
        }).toList();
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    double HEADER_HEIGHT = 4.5;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: HappiFeetAppBar(IsDashboard: false, isCitiyList: false,callback: (){
        log("CALLBACK CALLED IN LOCATION LISTING");
        Navigator.of(context).pop();
      })
          .getAppBar(context),
      body:
          // locationDetails.isEmpty ? CircularProgressIndicator() :
          SafeArea(
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
                                  ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                                  ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!)
                                ],
                              )),
                          child: Container(
                            margin: DeviceDimensions.getHeaderEdgeInsets(context),
                            child:  Center(
                              child: Text(
                                "Manage Locations",
                                // "Select Location".tr(),
                                // "Select Location".language(context),
                                // widget.selectedLanguage == "1" ? 'Select Location'.language(context) : 'Select Location',
                                style: TextStyle(
                                    color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_text_color!),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )),
                   Container(
                     height:
                     DeviceDimensions.getBottomSheetHeight(context, HEADER_HEIGHT),
                     margin: EdgeInsets.only(
                         top: DeviceDimensions.getBottomSheetMargin(
                             context, HEADER_HEIGHT)),
                     padding: const EdgeInsets.symmetric(horizontal: 16),
                     decoration: const BoxDecoration(
                         borderRadius: BorderRadius.only(
                             topLeft: Radius.circular(25),
                             topRight: Radius.circular(25)),
                         color: Colors.white),
                     // color: Colors.white,
                    child: RefreshIndicator(
                      backgroundColor: Colors.white,
                      color: ColorParser().hexToColor("#1A7C52"),
                      onRefresh: () => getLocationDetails(),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /** Search bar **/
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 26),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: SizedBox(
                                      height: 50,
                                      width: 400,
                                      child: TextField(
                                          onChanged: (value) {
                                            filterSearchResults(value);
                                          },
                                          style: const TextStyle(fontSize: 16),
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(Icons.search),
                                            prefixIconColor:
                                                ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                                            labelText: 'Search',
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
                            /**   listview builder     **/

                            /**  Location Listing **/

                            Flexible(
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                physics: const ScrollPhysics(),
                                itemCount: locationDetails.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return LocationCard(
                                      locationDetails: locationDetails[index],
                                      eventListener: (event) {
                                        switch (event) {
                                          case events.DELETE:
                                            getLocationDetails();
                                            setState(() {});
                                            break;
                                          case events.EDIT:
                                            setState(() {});
                                            break;
                                          case events.QR:
                                            setState(() {});
                                            break;
                                        }
                                      });
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 8,
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                    ],
                  ),
          ),
      bottomSheet: Container(
        height: 50,
        color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  AddLocation.gotoAddLocation(context, false, null);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                    elevation: 0),
                child: Text(
                  "Add Location",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
