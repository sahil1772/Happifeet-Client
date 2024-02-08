import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/screens/Manage/ManageClients/AddClient.dart';

import '../../../components/ClientListingCard.dart';
import '../../../components/HappiFeetAppBar.dart';
import '../../../model/ClientUsers/ClientUserData.dart';
import '../../../storage/runtime_storage.dart';
import '../../../storage/shared_preferences.dart';
import '../../../utils/ColorParser.dart';
import '../../../utils/DeviceDimensions.dart';

Future? futureClientData;

class ClientListingWidget extends StatefulWidget {
  gotoClientListingPage(BuildContext context) async {
    Navigator.push(
            context, MaterialPageRoute(builder: (_) => ClientListingWidget()))
        .then((value) {
      log("VALUE IN CALLBACK${value}");
    });
  }

  @override
  State<ClientListingWidget> createState() => _ClientListingWidgetState();
}

class _ClientListingWidgetState extends State<ClientListingWidget> {
  List<ClientUserData> clientUserData =[];
  List<ClientUserData> clientUserDataTemp =[];

  @override
  void initState() {
    // TODO: implement initState
    futureClientData = getClientUserData();
    super.initState();
  }

  Future<void> getClientUserData() async {
    setState(() {

    });
    var response = await ApiFactory().getClientService().getClientUserData(
        "list_client_users", await SharedPref.instance.getUserId());
   setState(() {
     clientUserData = response;
     clientUserDataTemp = response;
   });
    log("CLIENT USER DATA ${clientUserData!.first.toJson()}");
  }

  filterSearchResults(String keyword) {
    log("search keyword ${keyword}");

    setState(() {
      if (keyword.isEmpty) {
        clientUserData = clientUserDataTemp;
      } else {
        clientUserData = clientUserDataTemp.where((element) {
          return (element as ClientUserData)
              .client_name!
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
      resizeToAvoidBottomInset: true,
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
                      "List Assigned Client",
                      // "Select Location".tr(),
                      // "Select Location".language(context),
                      // widget.selectedLanguage == "1" ? 'Select Location'.language(context) : 'Select Location',
                      style: TextStyle(
                          color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_text_color!),
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
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
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: RefreshIndicator(
                        onRefresh: () => getClientUserData(),
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
                                            prefixIconColor: ColorParser()
                                                .hexToColor("#1A7C52"),
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

                            /**  Client user Listing **/

                            FutureBuilder(
                              future: futureClientData,
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Flexible(
                                    child: ListView.separated(
                                      padding: EdgeInsets.zero,
                                      physics: const ScrollPhysics(),
                                      itemCount: clientUserData!.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return ClientListingCard(
                                            clientUserData:
                                                clientUserData![index],refreshCallback: (){
                                              setState(() {
                                                futureClientData = getClientUserData();

                                              });
                                        },);
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const SizedBox(
                                          height: 8,
                                        );
                                      },
                                    ),
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else {
                                  return const Text("Something Went Wrong");
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
                  AddClientWidget().gotoAddClientPage(context, null, false,(){
                    setState(() {
                      print("REFRESH KARTOY BHAVAAAAAAAAAAAAAAAaaaa");
                      futureClientData = getClientUserData();

                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                    elevation: 0),
                child: const Text(
                  "Add Client",
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
