import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/components/CommentsCard.dart';
import 'package:happifeet_client_app/model/Comments/CommentData.dart';
import 'package:happifeet_client_app/model/FilterMap.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/screens/Reports/CommentsFilterPage.dart';
import 'package:happifeet_client_app/storage/runtime_storage.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';

import '../../components/HappiFeetAppBar.dart';
import '../../utils/ColorParser.dart';
import '../../utils/DeviceDimensions.dart';

class CommentsWidget extends StatefulWidget {
  const CommentsWidget({super.key});

  gotoCommentsWidget(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const CommentsWidget()));
  }


  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();

}

class _CommentsWidgetState extends State<CommentsWidget> {
  Future<List<CommentData>?>? commentResponse;


  FilterMap? filterParams = FilterMap(
      type: FilterType.Park.name,
      popupDatepickerToDateSearch:
          DateFormat("yyyy-MM-dd").format(DateTime.now()),
      popupDatepickerFromDateSearch:
          DateFormat("yyyy-MM-dd").format(DateTime.now()));



  @override
  void initState() {



    getComments();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double HEADER_HEIGHT = 4.5;
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      drawer: CommentsFilterpageWidget(
        filterData: (params) {
          filterParams = params;
          getComments();
        },
        params: filterParams,
      ),
      appBar: HappiFeetAppBar(IsDashboard: false, isCitiyList: false)
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
                      "Comments",
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
                                          prefixIcon: InkWell(
                                              onTap: () {
                                                // FilterpageWidget().gotoFilterPage(
                                                //     context);
                                                Navigator.of(context).push(_createRoute());
                                              },
                                              child: SvgPicture.asset(
                                                  "assets/images/comments/filter.svg",colorFilter: ColorFilter.mode(ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!), BlendMode.srcIn),)),
                                          prefixIconConstraints: BoxConstraints(
                                              minHeight: 30, minWidth: 60),

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

                        Flexible(
                          child: FutureBuilder<List<CommentData>?>(
                            future: commentResponse,
                            builder: (context, snapshot) {
                              Widget toReturn = const Padding(
                                  padding: EdgeInsets.all(64.0),
                                  child: Center(
                                      child: CircularProgressIndicator()));

                              switch (snapshot.connectionState) {
                                case ConnectionState.done:
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.isNotEmpty) {
                                      toReturn = ListView.separated(
                                        padding: EdgeInsets.zero,
                                        physics: const ScrollPhysics(),
                                        itemCount: snapshot.data!.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return CommentsCard(
                                            data: snapshot.data![index],
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return const SizedBox(
                                            height: 8,
                                          );
                                        },
                                      );
                                    } else {
                                      toReturn = const Padding(
                                        padding: EdgeInsets.all(64.0),
                                        child: Center(
                                            child: Text("No Comments Found.")),
                                      );
                                    }
                                  }
                                  break;
                                case ConnectionState.none:
                                  break;
                                case ConnectionState.active:
                                  break;
                                case ConnectionState.waiting:
                                  break;
                              }
                              return toReturn;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),

          ],
        ),
      ),

    );
  }

  getComments() {
    commentResponse = ApiFactory.getCommentService().getComments(filterParams);
    setState(() {});
  }
}