import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/screens/Manage/ManageUsers/AddAssignedUser.dart';
import 'package:happifeet_client_app/storage/runtime_storage.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../components/HappiFeetAppBar.dart';
import '../../../components/UserListingCard.dart';
import '../../../model/AssignedUsers/AssignedUserData.dart';
import '../../../utils/ColorParser.dart';
import '../../../utils/DeviceDimensions.dart';

class AssignedUserListing extends StatefulWidget {
  PersistentTabController? controller;
   AssignedUserListing({super.key,this.controller});

  @override
  State<AssignedUserListing> createState() => _AssignedUserListingState();



  goToAssignedUserListing(BuildContext context,Function? callback,PersistentTabController? controller) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) =>  AssignedUserListing(controller:controller)));
  }
}

class _AssignedUserListingState extends State<AssignedUserListing> {
  List<AssignedUserData> assignedUserdata = [];
  List<AssignedUserData> assignedUserdataTemp = [];
  Future? userListing;

  @override
  void initState() {
    // TODO: implement initState
    userListing = getAssignedUserListing();
    super.initState();
  }

  Future<void> getAssignedUserListing() async {
    setState(() {

    });
    var response = await ApiFactory().getUserService().getUserData(
        "list_assigned_users", await SharedPref.instance.getUserId());
setState(() {
  assignedUserdata = response;
  assignedUserdataTemp = response;
});
    log("ASSIGNED USER LISTING ${assignedUserdata!.first.toJson()}");


  }

  filterSearchResults(String keyword) {
    log("search keyword ${keyword}");

    setState(() {
      if (keyword.isEmpty) {
        assignedUserdata = assignedUserdataTemp;
      } else {
        assignedUserdata = assignedUserdataTemp.where((element) {
          return (element as AssignedUserData)
              .name!
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
      body: SafeArea(
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
                      "List Assigned User",
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
                    child: RefreshIndicator(
                      backgroundColor: Colors.white,
                      color: ColorParser().hexToColor("#1A7C52"),
                      onRefresh: () => getAssignedUserListing(),
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

                            /**  assigned user Listing **/

                            FutureBuilder(
                              future: userListing,
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if(snapshot.connectionState == ConnectionState.done){
                                  return Flexible(
                                    child: ListView.separated(
                                      padding: EdgeInsets.zero,
                                      physics: const ScrollPhysics(),
                                      itemCount: assignedUserdata!.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return  UserListingCard(assignedUserdata: assignedUserdata![index],refreshCallback:(){
                                          log("CARD REFRESHED ON EDIT");
                                         setState(() {
                                           userListing = getAssignedUserListing();
                                         });

                                        });
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const SizedBox(
                                          height: 8,
                                        );
                                      },
                                    ),
                                  );
                                }else if(snapshot.connectionState == ConnectionState.waiting){
                                  return CircularProgressIndicator();
                                }else{
                                  return Text("Something Went Wrong");
                                }

                              },
                            ),
                            const SizedBox(
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
                  AddAssignedUserWidget().goToAddAssignedUser(context,null,false,(){
                    log("UPDATE USER LISTING ON BACK!!");
                   setState(() {
                     userListing = getAssignedUserListing();
                   });

                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                    elevation: 0),
                child: const Text(
                  "Add User",
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
