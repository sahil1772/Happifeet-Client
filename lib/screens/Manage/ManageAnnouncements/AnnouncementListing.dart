import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/screens/Manage/ManageAnnouncements/AddAnnouncement.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';

import '../../../components/AnnouncementCard.dart';
import '../../../components/HappiFeetAppBar.dart';
import '../../../model/Announcement/AnnouncementData.dart';
import '../../../storage/runtime_storage.dart';
import '../../../utils/ColorParser.dart';
import '../../../utils/DeviceDimensions.dart';

class AnnouncementListingWidget extends StatefulWidget {
  static gotoAnnouncementListingPage(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => AnnouncementListingWidget()));
  }

  @override
  State<AnnouncementListingWidget> createState() =>
      _AnnouncementListingWidgetState();
}

class _AnnouncementListingWidgetState extends State<AnnouncementListingWidget> {
  List<AnnouncementData> announcementlisting = [];
  List<AnnouncementData> announcementlistingTemp = [];

  Future? apiResponse;

  @override
  void initState() {
    // TODO: implement initState
    apiResponse = getAnnouncmentListing();
    super.initState();
  }

  getAnnouncmentListing() async {
    setState(() {});
    var response = await ApiFactory()
        .getAnnouncementService()
        .getAnnouncementList(
            "getAnnoucement", await SharedPref.instance.getClientId());
    setState(() {
      announcementlisting = response;
      announcementlistingTemp = response;
    });
    log("DATA IN RESPONSE OF ANNOUNCMEENMT LIST ${announcementlisting!.first.toJson()}");
  }

  filterSearchResults(String keyword) {
    log("search keyword ${keyword}");

    setState(() {
      if (keyword.isEmpty) {
        announcementlisting = announcementlistingTemp;
      } else {
        announcementlisting = announcementlistingTemp.where((element) {
          return (element as AnnouncementData)
              .title!
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
                                "List Announcements",
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
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /** Search bar **/
                          Padding(
                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: 8, vertical: 26),

                            padding: const EdgeInsets.only(
                                left: 8, top: 20, right: 8, bottom: 20),
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
                                          prefixIcon: Icon(Icons.search),
                                          // prefixIcon: InkWell(
                                          //     onTap: () {
                                          //       // FilterpageWidget().gotoFilterPage(
                                          //       //     context);
                                          //       // Navigator.of(context).push(_createRoute());
                                          //     },
                                          //     child: SvgPicture.asset(
                                          //     child: SvgPicture.asset(
                                          //         "assets/images/comments/filter.svg")),
                                          prefixIconConstraints: BoxConstraints(
                                              minHeight: 30, minWidth: 60),
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

                          /**  Comments card Listing **/

                          FutureBuilder(
                            future: apiResponse,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Flexible(
                                  child: ListView.separated(
                                    padding: EdgeInsets.zero,
                                    physics: const ScrollPhysics(),
                                    itemCount: announcementlisting!.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return AnnouncementCard(
                                        announcemntData:
                                            announcementlisting![index],
                                        callback: () {
                                          setState(() {
                                            context.setLocale(const Locale("en"));
                                            apiResponse = getAnnouncmentListing();
                                          });
                                        },
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        height: 8,
                                      );
                                    },
                                  ),
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                return Text("Something Went Wrong");
                              }
                            },
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
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
                  // AddLocation().gotoAddLocation(context);
                  AddAnnouncementWidget.gotoAddAnnouncementPage(
                      context, false, null, () {
                    setState(() {
                      context.setLocale(const Locale("en"));
                      apiResponse = getAnnouncmentListing();
                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                    elevation: 0),
                child: Text(
                  "Add Announcement",
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
