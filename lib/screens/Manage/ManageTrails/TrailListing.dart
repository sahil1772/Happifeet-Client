import 'package:flutter/material.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/screens/Manage/ManageTrails/AddTrail.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:happifeet_client_app/utils/DeviceDimensions.dart';

import '../../../components/HappiFeetAppBar.dart';
import '../../../components/TrailListingCard.dart';
import '../../../model/Trails/TrailListingData.dart';
import '../../../storage/runtime_storage.dart';
import '../../../utils/ColorParser.dart';

class TrailListing extends StatefulWidget {
  const TrailListing({super.key});

  @override
  State<TrailListing> createState() => _TrailListingState();

  static goToTrailListing(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => TrailListing()));
  }
}

class _TrailListingState extends State<TrailListing> {
  Future<List<TrailListingData>?>? trailListing;
  List<TrailListingData>? trailList;

  @override
  void initState() {
    // TODO: implement initState
    trailListing = getTrailListing();
    super.initState();
  }

  Future<List<TrailListingData>> getTrailListing() async {
    // var response = await ApiFactory()
    //     .getTrailService()
    //     .getTrailListing(await SharedPref.instance.getUserId());
    // trailList = response;
    // log("TRAIL LISTING DATA ${trailList!.first}");
    return ApiFactory()
        .getTrailService()
        .getTrailListing(await SharedPref.instance.getUserId());
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
                      "List Trails",
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
                onRefresh: () => getTrailListing(),
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

                      /**  TRAIL LISTING **/

                      FutureBuilder<List<TrailListingData>?>(
                        future: trailListing,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            trailList = snapshot.data;

                            return Flexible(
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                physics: const ScrollPhysics(),
                                itemCount: trailList!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return TrailListingCard(
                                    trailList: trailList![index],
                                    callback: () {
                                      trailListing = getTrailListing();
                                      setState(() {});
                                    },
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(
                                    height: 8,
                                  );
                                },
                              ),

                              // else if(snapshot.connectionState == ConnectionState.waiting){
                              //   return CircularProgressIndicator();
                              // }else{
                              //   return Text("Something Went Wrong");
                              // }
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
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
            )
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
                  AddTrail.goToAddTrail(context, false, null, () {
                    trailListing = getTrailListing();
                    setState(() {});
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                    elevation: 0),
                child: const Text(
                  "Add Trail",
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
