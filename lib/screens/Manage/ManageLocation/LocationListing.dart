import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:happifeet_client_app/components/LocationCard.dart';
import 'package:happifeet_client_app/screens/Manage/ManageLocation/AddLocation.dart';

import '../../../components/HappiFeetAppBar.dart';
import '../../../model/Location/LocationData.dart';
import '../../../network/ApiFactory.dart';
import '../../../utils/ColorParser.dart';

class LocationListing extends StatefulWidget {
  gotoManageLocation(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => LocationListing()));
  }

  @override
  State<LocationListing> createState() => _ManageLocationWidgetState();
}

class _ManageLocationWidgetState extends State<LocationListing> {
  List<LocationData> locationDetails = [];
  List<LocationData> locationDetailsTemp = [];

  @override
  void initState() {
    // TODO: implement initState
    getLocationDetails();
    super.initState();
  }

  void getLocationDetails() async {
    var response = await ApiFactory()
        .getLocationService()
        .getLocationListData("list_location");

    // var response = await ApiFactory().getLocationService().submitLocationData(data)
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
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 8),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Manage Location",
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
                                        // filterSearchResults(value);
                                      },
                                      style: const TextStyle(fontSize: 16),
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.search),
                                        prefixIconColor:
                                            ColorParser().hexToColor("#1A7C52"),
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
                  AddLocation.gotoAddLocation(context, false, null);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorParser().hexToColor("#1A7C52"),
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
