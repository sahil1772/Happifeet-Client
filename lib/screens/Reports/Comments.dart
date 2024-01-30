import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/components/CommentsCard.dart';
import 'package:happifeet_client_app/model/Comments/CommentData.dart';
import 'package:happifeet_client_app/model/FilterMap.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/screens/Reports/CommentsFilterPage.dart';

import '../../components/HappiFeetAppBar.dart';
import '../../utils/ColorParser.dart';

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

  FilterMap filterParams = FilterMap();

  @override
  void initState() {
    getComments();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      drawer: CommentsFilterpageWidget(
        filterData: (params) {
          filterParams = params;
          getComments();
        },params: filterParams,
      ),
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
                        "Comments",
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
                                        prefixIcon: Builder(builder: (context) {
                                          return InkWell(
                                              onTap: () {
                                                Scaffold.of(context)
                                                    .openDrawer();
                                              },
                                              child: SvgPicture.asset(
                                                  "assets/images/comments/filter.svg"));
                                        }),
                                        prefixIconConstraints:
                                            const BoxConstraints(
                                                minHeight: 30, minWidth: 60),
                                        prefixIconColor:
                                            ColorParser().hexToColor("#1A7C52"),
                                        labelText: ' Filters',
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
                                          return CommentsCard(data: snapshot.data![index],);
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
                );
              })
        ],
      ),
    );
  }

  getComments() {
    commentResponse = ApiFactory.getCommentService().getComments(filterParams);
    setState(() {

    });
  }
}
